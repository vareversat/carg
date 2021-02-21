from google.cloud import firestore


def migrate_coinche_players_schema():
    db = firestore.Client()
    games = db.collection(u'coinche-game-prod').get()

    for game in games:
        us_id = game.to_dict()['us']
        them_id = game.to_dict()['them']
        dict_game = game.to_dict()

        us_players = db.collection(u'team-prod').document(us_id).get().to_dict()['players']
        them_players = db.collection(u'team-prod').document(them_id).get().to_dict()['players']
        player_list = us_players + them_players

        players = {"playerList": player_list, "us": us_id, "them": them_id}
        dict_game['players'] = players
        dict_game['us'] = None
        dict_game['them'] = None

        game.reference.update({u'players': {"playerList": player_list, "us": us_id, "them": them_id}})
        game.reference.update({u'us': None})
        game.reference.update({u'them': None})

        print("########")


def migrate_tarot_players_schema():
    db = firestore.Client()
    games = db.collection(u'tarot-game-prod').get()

    for game in games:
        player_list = game.to_dict()['players']

        players = {"payer_list": player_list}

        game.reference.update({u'players': players})

        print("########")


def migrate_card_color_name():
    db = firestore.Client()
    scores = db.collection(u'coinche-score-prod').get()

    for score in scores:
        rounds = score.to_dict()['rounds']
        if (type(rounds) == list):
            for rd in rounds:
                rd_dict = rd
                if (rd_dict['card_color'] == 'COEUR'):
                    rd_dict['card_color'] = 'HEART'
                if (rd_dict['card_color'] == 'TREFLE'):
                    rd_dict['card_color'] = 'CLUB'
                if (rd_dict['card_color'] == 'CARREAU'):
                    rd_dict['card_color'] = 'DIAMOND'
                if (rd_dict['card_color'] == 'PIC'):
                    rd_dict['card_color'] = 'SPADE'
                if (rd_dict['card_color'] == 'TOUT_ATOUT'):
                    rd_dict['card_color'] = 'ALL_TRUMP'
                if (rd_dict['card_color'] == 'SANS_ATOUT'):
                    rd_dict['card_color'] = 'NO_TRUMP'
            score.reference.update({u'rounds': rounds})
        print("########")


def main():
    migrate_card_color_name()


if __name__ == "__main__":
    main()
