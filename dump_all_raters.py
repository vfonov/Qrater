import pandas as pd
from sqlalchemy import create_engine
import argparse


def parse_options():
    parser = argparse.ArgumentParser(description='Dump all ratings into an feather file')

    parser.add_argument("-p", default="db-password.txt",
                        help="DB-password file")

    parser.add_argument("out",
                        help="Destination feather file")


    params = parser.parse_args()

    return params

def main():
    params = parse_options()

    pwd=open(params.p,'r').readlines()[0].strip("\n")

    engine = create_engine(f'mysql+pymysql://root:{pwd}@127.0.0.1:3306/qrater', echo=False)

    df=pd.read_sql(
"""
select 
  d.name as dataset,i.name as image_name,i.path as image_path,i.subject as subject,i.session as session,i.cohort as cohort,r.rating as rating_id,r.comment as comment,u.username as rater_name
  from image as i inner join rating as r on r.image_id=i.id inner join dataset as d on i.dataset_id=d.id inner join rater as u on u.id=r.rater_id;
""",
#'select d.name as dataset,i.name as image_name,i.path as image_path,i.subject as subject,i.session as session,i.cohort as cohort,r.rating as rating_id,r.comment as comment,u.username as rater_name from image as i inner join rating as r on r.image_id=i.id inner join dataset as d on i.dataset_id=d.id inner join rater as u on u.id=r.rater_id;',
	engine)

    print(df.head())
    print(df.shape)

    df.to_feather(params.out)

if __name__ == "__main__":
    main()
