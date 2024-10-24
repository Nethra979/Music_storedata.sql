/* Q1: Who is the senior most employee based on job title? */

Select * from Employee
Order by levels desc
limit 1

/* Q2: Which countries have the most Invoices? */

Select COUNT(*) as c, billing_country 
from Invoice
Group by billing_country
Order by c desc

/* Q3: What are top 3 values of total invoice? */

select total from Invoice
Order by total desc
limit 3


/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select SUM(total) as Invoice_total, billing_city
from Invoice
Group by billing_city
Order by Invoice_total desc



/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/


SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN Invoice ON customer.customer_id = Invoice.customer_id
Group by customer.customer_id
Order by total_spending desc
limit 1; 





/* Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */


SELECT DISTINCT email, first_name, last_name 
	from customer 
JOIN Invoice ON customer.customer_id = Invoice.customer_id
JOIN Invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id from track 
    JOIN genre ON track.genre_id = genre.genre_id
    WHERE genre.name like 'Rock'
)	
ORDER BY email;


/* Q2: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */



SELECT artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
 Group by artist.artist_id 
 Order by number_of_songs DESC
LIMIT 10;	



/* Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_length
	FROM track 
	)
ORDER BY milliseconds DESC;




/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */


WITH best_selling_artist AS (
	select artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price * invoice_line.quantity) AS Total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)	

	SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
	SUM(il.unit_price *il.quantity) AS amount_spent
	FROM invoice i
	JOIN customer c ON c.customer_id = i.customer_id
	JOIN invoice_line il ON il.invoice_id = i.invoice_id
	JOIN track t ON t.track_id = il.track_id
	JOIN album alb ON alb.album_id = t.album_id
	JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
	GROUP By 1,2,3,4
	ORDER BY 5 DESC
	
