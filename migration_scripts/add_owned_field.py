from google.cloud import firestore


def add_owned_by_field():
    db = firestore.Client()
    players = db.collection(u'player-prod').get()
    default_id = 'CV3Mf56qVGd22CjeEcA8'

    for player in players:
        player_dict = player.to_dict()
        print(player_dict['user_name'])

        add_default_id = input('Add ' + default_id + ' ? :')

        if add_default_id == 'no':
            print('NOTHING TO DO')
            player.reference.update({u'owned': False})
        else:
            print('OK')
            player.reference.update({u'owned': True})
            player.reference.update({u'owned_by': default_id})

        print("########")


def main():
    add_owned_by_field()


if __name__ == "__main__":
    main()
