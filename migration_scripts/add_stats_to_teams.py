from google.cloud import firestore


def add_stats_to_teams():
    db = firestore.Client()
    teams = db.collection(u'team-prod').get()

    for team in teams:
        team_dict = team.to_dict()
        won_games = team_dict['won_games']
        played_games = team_dict['played_games']
        game_stat = [{'game_type': 'COINCHE', 'won_games': won_games, 'played_games': played_games}]

        team.reference.update({u'game_stats': game_stat})
        input('OK ?')

        print("########")


def main():
    add_stats_to_teams()


if __name__ == "__main__":
    main()
