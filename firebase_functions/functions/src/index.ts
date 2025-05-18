import * as functions from 'firebase-functions';
import * as firestore from "@google-cloud/firestore";
import { algoliasearch } from 'algoliasearch';

import * as algolia_key from "./assets/algolia-key.json";
import * as google_key from "./assets/backup-service-key.json";

const algoliaClient = algoliasearch(algolia_key.app_id, algolia_key.api_key);
const firestoreClient = new firestore.v1.FirestoreAdminClient({
    credentials:
        { client_email: google_key.client_email, private_key: google_key.private_key }
});

const indexDev = 'player-dev';
const indexProd = 'player-prod';


// App functions
export const onPlayerWrittenDev = functions.firestore.onDocumentWritten('player-dev/{playerId}', (event: any) => {
    const player = event.data.after.data();
    if (player !== undefined) {
        return algoliaClient.addOrUpdateObject({ indexName: indexDev, body: player, objectID: event.params.playerId });
    } else {
        return algoliaClient.deleteObject({ indexName: indexDev, objectID: event.params.playerId });
    }
});

export const onPlayerWrittenProd = functions.firestore.onDocumentWritten('player-prod/{playerId}', (event: any) => {
    const player = event.data.after.data();
    if (player !== undefined) {
        return algoliaClient.addOrUpdateObject({ indexName: indexProd, body: player, objectID: event.params.playerId });
    } else {
        return algoliaClient.deleteObject({ indexName: indexProd, objectID: event.params.playerId });
    }
});

// Backup functions
export const backupFirestore = functions.scheduler.onSchedule({ schedule: 'every day 00:00', timeZone: 'Europe/Paris' }, async (event: any) => {

    try {
        const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT || '';
        const bucketName = `${projectId}-firestore-backup`;
        const databaseName = firestoreClient.databasePath(projectId, '(default)');
        const timestamp = new Date().toISOString();

        console.log(`Local starting time is ${timestamp}`);
        console.log(`Start to backup project ${projectId}`);

        const responses = await firestoreClient.exportDocuments({
            name: databaseName,
            outputUriPrefix: `gs://${bucketName}/backups/${timestamp}`,
            collectionIds: []
        });

        console.log(`Backup completed: ${responses[0].error}`);
    } catch (error) {
        console.error("Error during Firestore backup:", error);
        // Optionally, you can throw the error to mark the function execution as failed
        throw error;
    }

});
