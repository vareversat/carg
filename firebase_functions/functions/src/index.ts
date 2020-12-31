import * as functions from 'firebase-functions';
import algoliasearch from 'algoliasearch';

const ALGOLIA_APP_ID = 'A0M2ID7FCT';
const ALGOLIA_ADMIN_KEY = 'f897240bd9ba1dbaf4cbda253903f47a';

const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
const indexDev = client.initIndex('player_dev');
const indexProd = client.initIndex('player_prod');

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
