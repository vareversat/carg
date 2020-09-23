import * as functions from 'firebase-functions';
import algoliasearch from 'algoliasearch';

const ALGOLIA_APP_ID = 'A0M2ID7FCT';
const ALGOLIA_ADMIN_KEY = 'f897240bd9ba1dbaf4cbda253903f47a';
const ALGOLIA_INDEX_NAME = 'players';

let client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
const index = client.initIndex(ALGOLIA_INDEX_NAME);

export const onPlayerCreated = functions.firestore.document('player/{playerId}').onCreate((snap, context) => {
    const player = snap.data();
    if (player !== undefined) {
        player.objectID = context.params.playerId;
        return index.saveObject(player);
    }
    return 'Cannot add to index'
});

export const onPlayerCreated2 = functions.database.instance('carg-dev').ref('player/{playerId}').onCreate((snap, context) => {
    const player = snap.val();
    console.log('Added player : ', player);
    if (player !== undefined) {
        player.objectID = context.params.playerId;
        return index.saveObject(player);
    }
    return 'Cannot add to index'
});

export const onPlayerUpdated = functions.firestore.document('player/{playerId}').onUpdate((snap, context,) => {
    const newPlayer = snap.after.data();
    if (newPlayer !== undefined) {
        newPlayer.objectID = context.params.playerId;
        return index.saveObject(newPlayer);
    }
    return 'Cannot update index'
});

export const onPlayerUpdated2 = functions.database.instance('carg-dev').ref('/player/{playerId}').onUpdate((snap, context) => {
    const player = snap.after.val();
    console.log('Updated player : ', player);
    if (player !== undefined) {
        player.objectID = context.params.playerId;
        return index.saveObject(player);
    }
    return 'Cannot add to index'
});

export const onPlayerDeleted = functions.firestore.document('player/{playerId}').onDelete((snap, context,) => {
    return index.deleteObject(context.params.playerId);
});

export const onPlayerDeleted2 = functions.database.instance('carg-dev').ref('player/{playerId}').onDelete((snap, context) => {
    return index.deleteObject(context.params.playerId);
});
