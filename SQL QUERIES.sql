USE AMAZON_SALES;
CREATE TABLE amazon_products_1 (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    discounted_price DECIMAL(10,2),
    actual_price DECIMAL(10,2),
    discount_percentage DECIMAL(5,4),
    rating DECIMAL(3,2),
    rating_count INT,
    about_product TEXT,
    user_id TEXT,
    user_name TEXT,
    review_id TEXT,
    review_title TEXT,
    review_content TEXT,
    img_link TEXT,
    product_link TEXT
);

-- Load data directly into the amazon_products table
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/jup_amaz_cleaned1.csv"
INTO TABLE amazon_products_1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(product_id, product_name, category, discounted_price, actual_price, discount_percentage, rating, rating_count, about_product, user_id, user_name, review_id, review_title, review_content, img_link, product_link);

-- Perform the update operation to handle any duplicate records
UPDATE amazon_products_1 AS ap
JOIN (
    SELECT * FROM amazon_products_1
    WHERE product_name IS NOT NULL
) AS apt ON ap.product_id = apt.product_id
SET 
    ap.product_name = apt.product_name,
    ap.category = apt.category,
    ap.discounted_price = apt.discounted_price,
    ap.actual_price = apt.actual_price,
    ap.discount_percentage = apt.discount_percentage,
    ap.rating = apt.rating,
    ap.rating_count = apt.rating_count,
    ap.about_product = apt.about_product,
    ap.user_id = apt.user_id,
    ap.user_name = apt.user_name,
    ap.review_id = apt.review_id,
    ap.review_title = apt.review_title,
    ap.review_content = apt.review_content,
    ap.img_link = apt.img_link,
    ap.product_link = apt.product_link
WHERE ap.product_id IN (SELECT product_id FROM amazon_products WHERE product_name IS NULL);
ALTER TABLE amazon_products_1 DROP PRIMARY KEY;
-- Optional: Verify the updated data
SELECT * FROM amazon_products_1 LIMIT 10;


-- 1 Find the top 3 products with the highest discount percentage in each category.

SELECT category, product_name, discount_percentage
FROM amazon_products_1
WHERE discount_percentage IS NOT NULL
ORDER BY category, discount_percentage DESC
LIMIT 3;

-- 2 List all the products with a rating of 4 or higher and have at least 50 ratings.

SELECT product_name, rating, rating_count
FROM amazon_products_1
WHERE rating >= 4 AND rating_count >= 50;

-- 3 What is the average discounted price for each category?

SELECT category, AVG(discounted_price) AS average_discounted_price
FROM amazon_products_1
GROUP BY category;

-- 4 How many products have a discount percentage greater than 30%?

SELECT COUNT(*) AS discounted_products
FROM amazon_products_1
WHERE discount_percentage > 30;

-- 5 Which product has the most reviews, and how many reviews does it have?

SELECT product_name, COUNT(review_id) AS review_count
FROM amazon_products_1
GROUP BY product_name
ORDER BY review_count DESC
LIMIT 1;

-- 6 List the users who have written reviews for products with a rating above 4.

SELECT DISTINCT user_id, user_name,review_content
FROM amazon_products_1
WHERE rating > 4;

-- 7 Find the product with the highest difference between its actual price and discounted price.

SELECT product_name, (actual_price - discounted_price) AS price_difference
FROM amazon_products_1
ORDER BY price_difference DESC
LIMIT 1;

-- 8 What is the total number of reviews for products in each category?

SELECT category, COUNT(review_id) AS total_reviews
FROM amazon_products_1
GROUP BY category;

-- 9 Find the most common review title for each product.

SELECT product_name, review_title, COUNT(*) AS title_count
FROM amazon_products_1
GROUP BY product_name, review_title
ORDER BY title_count DESC;

-- 10 Which category has the highest average rating, considering products with at least 20 reviews?

SELECT category, AVG(rating) AS average_rating
FROM amazon_products_1
WHERE rating_count >= 20
GROUP BY category
ORDER BY average_rating DESC
LIMIT 1;

-- 11 What is the rating distribution for each product in terms of rating count (e.g., how many products have a rating of 5, 4, etc.)?

SELECT rating, COUNT(*) AS product_count
FROM amazon_products_1
GROUP BY rating
ORDER BY rating DESC;

-- 12 List all the products where the discounted price is greater than the actual price.

-- SELECT product_name, discounted_price, actual_price
-- FROM amazon_products_1
-- WHERE discounted_price > actual_price;

-- 13 Find the average rating for each user who has written at least 5 reviews.

SELECT user_name, AVG(rating) AS average_rating
FROM amazon_products_1
GROUP BY user_name
HAVING COUNT(review_id) >= 5;

-- 14 What is the total discount amount for each product?

SELECT product_name, (actual_price - discounted_price) AS total_discount
FROM amazon_products_1;

-- 15 Find the top 5 products with the highest ratings and the lowest discount percentages.

SELECT product_name, rating, discount_percentage
FROM amazon_products_1
ORDER BY rating DESC, discount_percentage ASC
LIMIT 5;
