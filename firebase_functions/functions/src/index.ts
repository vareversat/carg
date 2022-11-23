import * as functions from 'firebase-functions';
import algoliasearch from 'algoliasearch';
import * as firestore from "@google-cloud/firestore";

import * as algolia_key from "./assets/algolia-key.json";
import * as google_key from "./assets/backup-service-key.json";

const algoliaClient = algoliasearch(algolia_key.app_id, algolia_key.api_key);
const firestoreClient = new firestore.v1.FirestoreAdminClient({credentials:
    {client_email: google_key.client_email, private_key: google_key.private_key }
});
const indexDev = algoliaClient.initIndex('player-dev');
const indexProd = algoliaClient.initIndex('player-prod');


// App functions
export const onPlayerCreatedDev = functions.firestore.document('player-dev/{playerId}').onCreate((snap, context) => {
    const player = snap.data();
    if (player !== undefined) {
        player.objectID = context.params.playerId;
        return indexDev.saveObject(player);
    }
    return 'Cannot add to index'

});

export const onPlayerUpdatedDev = functions.firestore.document('player-dev/{playerId}').onUpdate((snap, context,) => {
    const newPlayer = snap.after.data();
    if (newPlayer !== undefined) {
        newPlayer.objectID = context.params.playerId;
        return indexDev.saveObject(newPlayer);
    }
    return 'Cannot update index'

});

export const onPlayerDeletedDev = functions.firestore.document('player-dev/{playerId}').onDelete((snap, context,) => {
    return indexDev.deleteObject(context.params.playerId);
});

export const onPlayerCreatedProd = functions.firestore.document('player-prod/{playerId}').onCreate((snap, context) => {
    const player = snap.data();
    if (player !== undefined) {
        player.objectID = context.params.playerId;
        return indexProd.saveObject(player);
    }
    return 'Cannot add to index'

});

export const onPlayerUpdatedProd = functions.firestore.document('player-prod/{playerId}').onUpdate((snap, context,) => {
    const newPlayer = snap.after.data();
    if (newPlayer !== undefined) {
        newPlayer.objectID = context.params.playerId;
        return indexProd.saveObject(newPlayer);
    }
    return 'Cannot update index'

});

export const onPlayerDeletedProd = functions.firestore.document('player-prod/{playerId}').onDelete((snap, context,) => {
    return indexProd.deleteObject(context.params.playerId);
});

// Backup functions

export const backupFirestore = functions.pubsub.schedule('every day 00:00').timeZone('Europe/Paris').onRun(async (context) => {
    const projectId = process.env.GCP_PROJECT || process.env.GCLOUD_PROJECT || '';
    const bucketName = `${projectId}-firestore-backup`;
    const databaseName = firestoreClient.databasePath(projectId,'(default)');
    const timestamp = new Date().toISOString();

    console.log(`Local starting time is ${timestamp}`);
    console.log(`Start to backup project ${projectId}`);

    return firestoreClient.exportDocuments({
        name: databaseName,
        outputUriPrefix: `gs://${bucketName}/backups/${timestamp}`,
        collectionIds: []
    });

});
