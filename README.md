This SQL script creates a database schema for a social media platform, with tables for users, posts, likes, comments, shares, friends, and pages. It also inserts sample data into the tables for testing purposes. 

  

The users table has columns for user_id, username, email, password, gender, date_of_birth, phone_number, profile_pic, and joined_at. The user_id column is the primary key, and the email column has a unique constraint. 

  

The posts table has columns for post_id, user_id, post_content, post_pic, post_count, like_count, comment_count, share_count, and post_time. The post_id column is the primary key, and the user_id column has a foreign key constraint referencing the user_id column in the users table. 

  

The likes table has columns for like_id, user_id, post_id, and like_time. The like_id column is the primary key, and the user_id and post_id columns have foreign key constraints referencing the user_id and post_id columns in the users and posts tables, respectively. 

  

The comments table has columns for comment_id, user_id, post_id, comment_content, and comment_time. The comment_id column is the primary key, and the user_id and post_id columns have foreign key constraints referencing the user_id and post_id columns in the users and posts tables, respectively. 

  

The shares table has columns for share_id, user_id, post_id, and share_time. The share_id column is the primary key, and the user_id and post_id columns have foreign key constraints referencing the user_id and post_id columns in the users and posts tables, respectively. 

  

The likesoncomments table has columns for like_on_comment_id, user_id, comment_id, and like_on_comment_time. The like_on_comment_id column is the primary key, and the user_id and comment_id columns have foreign key constraints referencing the user_id and comment_id columns in the users and comments tables, respectively. 
