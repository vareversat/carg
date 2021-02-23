from google.cloud import firestore


def migrate_players_stats():
    db = firestore.Client()
    players = db.collection(u'player-prod').get()

    for player in players:
        print(player.to_dict()['user_name'])

        played_coinche = input("Played coinche: ")
        won_coinche = input("Won coinche: ")

        stat_coinche = {"game_type": "COINCHE", "won_games": won_coinche, "played_coinche": played_coinche}

        played_tarot = input("Played tarot: ")
        won_tarot = input("Won tarot: ")

        stat_tarot = {"game_type": "TAROT", "won_games": won_tarot, "played_coinche": played_tarot}

        stats = [stat_coinche, stat_tarot]

        player.reference.update({u'game_stats': stats})

        print(player.to_dict()['user_name'])
        print(stats)

        print("########")


def main():
    migrate_players_stats()


if __name__ == "__main__":
    main()
