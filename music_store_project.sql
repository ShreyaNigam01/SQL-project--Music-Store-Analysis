/* Senior most employee based on job title*/
select * from employee
order by levels desc
limit 1;

/* Countries with most number of invoices */
select billing_country,count(billing_country) as c_count 
from invoice
group by billing_country
order by c_count desc;

/*top three values of total invoices*/
select total from invoice
order by total desc
limit 3;

/* Which city has best customers,would like to throw a music festival in the city we made most money. 
Write a query that returns city with highest number of invoice total */

select billing_city, sum(total) as city_invoice_total
from invoice
group by billing_city
order by city_invoice_total desc;

/* who is the best customer? The person who has spent the most money will be declared the best cutomer. write the query
that returns the person who has spent the most money*/
select * from customer;

select c.customer_id ,c.first_name,c.last_name,sum(i.total) as s_total
from invoice i
join customer c on i.customer_id = c.customer_id 
group by c.customer_id
order by s_total desc
limit 1;
select * from invoice;

/* Find email,firstname, lastname of all rock music listeners. Return your list ordered alphabetically
by emailing start with A */
select  distinct c.email, c.first_name, c.last_name
from customer c 
join invoice i on c.customer_id =i.customer_id
join invoice_Line inv on i.invoice_id = inv.invoice_id
where track_id IN(
select track_id
from track t join Genre g on t.genre_id = g.genre_id
where g.name LIKE 'Rock')
order by email;

/* Invite the artist that has written most rock songs in our dataset. Write a query that returns 
the artist name and total track count of the top 10 rock bands*  artistname, */

select a.artist_id, a.name, count(t.track_id) num_of_track
from artist a 
join album al on a.artist_id = al.artist_id
join track t on al.album_id = t.album_id
where Genre_id = (
select genre_id
from genre
where name = 'Rock')				 
group by a.name, a.artist_id
order by num_of_track desc
limit 10;

/* Return all the track name that have the song length longer than the average song length.
Return the name and milliseconds for every track.Order by the song length wth the longest song listed
first 
select name , milliseconds 
from track
group by name
having milliseconds > avg(milliseconds)*/
select name, milliseconds from track
group by name, milliseconds
having milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

/* Find how much amount spent by each customer on artist? write a query to return customer name,
artist name and total spent
select i.customer_id, first_name,last_name, (il.unit_price * il.quantity) as total ,at.name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.unit_price = il.unit_price
join album a on a.album_id =t.album_id
join artist at on at.artist_id = a.artist_id
group by first_name, last_name,at.name,i.customer_id,total
--select * from invoice_line */

with demi as (
select ar.artist_id as artist_id, ar.name as artist_name, sum(il.unit_price*il.quantity) total_spend
from artist ar 
join album al on ar.artist_id = al.artist_id
join track t on al.album_id= t.album_id
join invoice_line il on il.track_id= t.track_id
group by ar.artist_id
	order by ar.artist_id
)
select  i.customer_id, c.first_name,c.last_name, d.artist_name, d.total_spend
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on il.track_id = t.track_id
join album al on al.album_id = t.album_id
join demi d on d.artist_id =al.artist_id
group by 1,2,3,4,5
order by 5 desc;

select c.country,  g.name , count(il.track_id) as track_count
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on il.track_id = t.track_id
join genre g on g.genre_id = t.genre_id
group by c.country, g.name
order by c.country, track_count;

/* Find the most popular song genre in each country, determine the most popular genre as the genre with
the highest amount of purchases. Write a query that returns each country along with the top genre
For countries where the maximum number of purchases is shared return all those genre*/

with demo as(
select c.country, count(il.quantity) as purchase,g.genre_id, g.name, 
ROW_NUMBER() OVER (PARTITION BY C.COUNTRY ORDER BY count(il.quantity)DESC ) AS ROW_NUM
FROM  customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on il.track_id = t.track_id
join genre g on g.genre_id = t.genre_id 
GROUP BY 1,3,4
ORDER BY 1 ASC, 2 DESC
)
SELECT * FROM DEMO WHERE ROW_NUM<=1;

/* Write a query that determines the customer that has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent. For countries
where top amount spent is shared, provide all customers that spend this amount.



