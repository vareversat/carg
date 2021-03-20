from google.cloud import firestore


def add_defender_field():
    db = firestore.Client()
    scores = db.collection(u'coinche-score-prod').get()

    for score in scores:
        rounds = score.to_dict()['rounds']
        for round in rounds:
            try:
                print(round['defender'])
            except KeyError:
                print('NO DEFENDER')
                taker = round['taker']
                if taker == 'US':
                    round['defender'] = 'THEM'
                else:
                    round['defender'] = 'US'
        score.reference.update({u'rounds': rounds})
        print("########")


def main():
    add_defender_field()


if __name__ == "__main__":
    main()
