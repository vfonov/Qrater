#! /bin/bash

docker exec qrater-db-1 /usr/bin/mysql -B --column-names -u root -p$(cat db-password.txt) qrater -e 'select d.name as dataset,i.name as image_name,i.path as image_path,i.subject as subject,i.session as session,i.cohort as cohort,r.rating as rating_id,r.comment as comment,u.username as rater_name from image as i inner join rating as r on r.image_id=i.id inner join dataset as d on i.dataset_id=d.id inner join rater as u on u.id=r.rater_id;'
