-- Creation of Tables 
 

-- Create Users table 

CREATE TABLE users ( 
  user_id INT PRIMARY KEY, 
  username VARCHAR2(50) NOT NULL, 
  email VARCHAR2(100) UNIQUE NOT NULL, 
  pass_word VARCHAR2(50) NOT NULL, 
  gender VARCHAR2(10) NOT NULL, 
  date_of_birth DATE NOT NULL, 
  phone_number VARCHAR2(10) NOT NULL, 
  profile_pic VARCHAR2(100) NOT NULL, 
  joined_at TIMESTAMP DEFAULT SYSTIMESTAMP 
) 
; 
  

-- Create Posts table 

CREATE TABLE posts ( 
  post_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  post_content VARCHAR2(500) NOT NULL, 
  post_pic VARCHAR2(100), 
  post_count INT, 
  like_count INT, 
  comment_count INT, 
  share_count INT, 
  post_time TIMESTAMP DEFAULT SYSTIMESTAMP, 
  CONSTRAINT fk_user 
    FOREIGN KEY (user_id) 
    REFERENCES Users(user_id) 
) 
;  
  

-- Create Likes table 

CREATE TABLE likes ( 
  like_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  post_id INT NOT NULL, 
  like_time TIMESTAMP DEFAULT SYSTIMESTAMP, 
  CONSTRAINT fk_post 
    FOREIGN KEY (post_id) 
    REFERENCES Posts(post_id) 
) 
; 
  

-- Create Comments table 

CREATE TABLE comments ( 
  comment_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  post_id INT NOT NULL, 
  comment_content VARCHAR2(500) NOT NULL, 
  comment_time TIMESTAMP DEFAULT SYSTIMESTAMP, 
  CONSTRAINT fk_post2 
    FOREIGN KEY (post_id) 
    REFERENCES Posts(post_id) 
) 
; 
  

-- Create Shares table 

CREATE TABLE shares ( 
  share_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  post_id INT NOT NULL, 
  share_time TIMESTAMP DEFAULT SYSTIMESTAMP, 
  CONSTRAINT fk_post3 
    FOREIGN KEY (post_id) 
    REFERENCES Posts(post_id) 
) 
; 
  

-- Create LikesOnComments table 

CREATE TABLE likesoncomments ( 
  like_on_comment_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  comment_id INT NOT NULL, 
  like_on_comment_time TIMESTAMP DEFAULT SYSTIMESTAMP, 
  CONSTRAINT fk_comment 
    FOREIGN KEY (comment_id) 
    REFERENCES Comments(comment_id) 
) 
; 
  

-- Create Friends table 

CREATE TABLE friends ( 
  friend_id INT PRIMARY KEY, 
  user_id INT NOT NULL, 
  friend_user_id INT NOT NULL, 
  friend_request_status VARCHAR2(20) NOT NULL, 
  CONSTRAINT fk_user_friend 
    FOREIGN KEY (user_id) 
    REFERENCES Users(user_id), 
  CONSTRAINT fk_user_friend2 
    FOREIGN KEY (friend_user_id) 
    REFERENCES Users(user_id) 
) 
; 
  

-- Create AllPages table 

CREATE TABLE allpages ( 
  page_id INT PRIMARY KEY, 
  page_name VARCHAR2(50) NOT NULL, 
  page_content VARCHAR2(500) NOT NULL 
) 
; 

  

-- Create UserPages table 

CREATE TABLE UserPages ( 
  user_id INT NOT NULL, 
  page_id INT NOT NULL, 
  CONSTRAINT pk_user_page 
    PRIMARY KEY (user_id, page_id), 
  CONSTRAINT fk_user_page 
    FOREIGN KEY (user_id) 
    REFERENCES Users(user_id), 
  CONSTRAINT fk_page_user 
    FOREIGN KEY (page_id) 
    REFERENCES AllPages(page_id) 
); 

  

-- Insertion of Data into the Tables 

  

-- Insert sample data into Users table  

INSERT INTO Users (user_id, username, email, pass_word, gender, date_of_birth, phone_number, profile_pic) 

SELECT level, 'user'||level, 'user'||level||'@example.com', 'p@ssw0rd'||level, CASE WHEN MOD(level, 2) = 0 THEN 'Male' ELSE 'Female' END, SYSDATE - INTERVAL '20' YEAR - DBMS_RANDOM.VALUE(1, 365*20), '987654'||level, 'profile_pic_'||level||'.jpg' FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into Posts table  

INSERT INTO Posts (post_id, user_id, post_content) SELECT level, DBMS_RANDOM.VALUE(1, 100), 'This is post number '||level FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into Likes table  

INSERT INTO Likes (like_id, user_id, post_id) SELECT level, DBMS_RANDOM.VALUE(1, 100), DBMS_RANDOM.VALUE(1, 100) FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into Comments table  

INSERT INTO Comments (comment_id, user_id, post_id, comment_content) SELECT level, DBMS_RANDOM.VALUE(1, 100), DBMS_RANDOM.VALUE(1, 100), 'This is comment number '||level FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into Shares table  

INSERT INTO Shares (share_id, user_id, post_id) SELECT level, DBMS_RANDOM.VALUE(1, 100), DBMS_RANDOM.VALUE(1, 100) FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into LikesOnComments table  

INSERT INTO LikesOnComments (like_on_comment_id, user_id, comment_id) SELECT level, DBMS_RANDOM.VALUE(1, 100), DBMS_RANDOM.VALUE(1, 100) FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into Friends table  

INSERT INTO Friends (friend_id, user_id, friend_user_id, friend_request_status) SELECT level, DBMS_RANDOM.VALUE(1, 100), DBMS_RANDOM.VALUE(1, 100), CASE WHEN MOD(level, 2) = 0 THEN 'accepted' ELSE 'pending' END FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into AllPages table  

INSERT INTO AllPages (page_id, page_name, page_content) 

SELECT (SELECT MAX(page_id) FROM AllPages) + level, 'Page '||level, 'This is the content of page '||level FROM dual CONNECT BY level <= 100; 

  

-- Insert sample data into UserPages table 

INSERT INTO UserPages (user_id, page_id) 
SELECT 
  u.user_id, 
  p.page_id 
FROM 
  (SELECT user_id FROM Users ORDER BY DBMS_RANDOM.VALUE) u, 
  (SELECT page_id FROM AllPages ORDER BY DBMS_RANDOM.VALUE) p 
WHERE 
  NOT EXISTS ( 
    SELECT 1 FROM UserPages up 
    WHERE up.user_id = u.user_id AND up.page_id = p.page_id 
  ) 
  AND ROWNUM <= 100; 

  

-- Triggers 
 

--Trigger to update post_count 

CREATE OR REPLACE TRIGGER update_post_count 
AFTER INSERT ON Posts 
FOR EACH ROW 
BEGIN 
  UPDATE Users SET post_count = post_count + 1 WHERE user_id = :NEW.user_id; 
END; 
/ 

  

--Trigger to update likes_count 

CREATE OR REPLACE TRIGGER update_likes_on_post 
AFTER INSERT ON likes 
FOR EACH ROW 
BEGIN 
  UPDATE posts 
  SET like_count = like_count + 1 
  WHERE post_id = :NEW.post_id; 
END; 
/ 

  

--Trigger to update shares_count 

CREATE OR REPLACE TRIGGER update_shares_on_post 
AFTER INSERT ON shares 
FOR EACH ROW 
BEGIN 
  UPDATE posts 
  SET share_count = share_count + 1 
  WHERE post_id = :NEW.post_id; 
END; 
/ 


--Trigger to update post_time 

CREATE OR REPLACE TRIGGER update_created_at_on_post 
BEFORE INSERT ON posts 
FOR EACH ROW 
BEGIN 
  :NEW.post_time := SYSTIMESTAMP; 
END; 
/ 

  

-- Procedures 
  

--Procedure to create a new user 

CREATE OR REPLACE PROCEDURE create_user( 
  p_username IN VARCHAR2, 
  p_email IN VARCHAR2, 
  p_pass_word IN VARCHAR2, 
  p_gender IN VARCHAR2, 
  p_date_of_birth IN DATE, 
  p_phone_number IN VARCHAR2, 
  p_profile_pic IN VARCHAR2 
) 
IS 
BEGIN 
  INSERT INTO users (user_id, username, email, pass_word, gender, date_of_birth, phone_number, profile_pic, joined_at) 
  VALUES (users_seq.NEXTVAL, p_username, p_email, p_pass_word, p_gender, p_date_of_birth, p_phone_number, p_profile_pic, SYSTIMESTAMP); 
END; 
/ 

  

--Procedure to create a new post 

CREATE OR REPLACE PROCEDURE create_post( 
  p_user_id IN INT, 
  p_post_content IN VARCHAR2, 
  p_post_pic IN VARCHAR2 
) 
IS 
BEGIN 
  INSERT INTO posts (post_id, user_id, post_content, privacy, post_time) 
  VALUES (posts_seq.NEXTVAL, p_user_id, p_post_content, p_privacy, SYSTIMESTAMP); 
END; 
/ 

  

--Procedure to like a post 

CREATE OR REPLACE PROCEDURE like_post( 
  p_user_id IN INT, 
  p_post_id IN INT 
) 
IS 
BEGIN 
  INSERT INTO likes (like_id, user_id, post_id, like_time) 
  VALUES (likes_seq.NEXTVAL, p_user_id, p_post_id, SYSTIMESTAMP); 
END; 
/ 


--Procedure to make comment and update comment count on a post 

CREATE OR REPLACE PROCEDURE make_comment( 
  p_user_id IN INT, 
  p_post_id IN INT, 
  p_comment_content IN VARCHAR2 
) 
IS 
BEGIN 
  INSERT INTO comments (comment_id, user_id, post_id, comment_content, comment_time) 
  VALUES (comments_seq.NEXTVAL, p_user_id, p_post_id, p_comment_content, SYSTIMESTAMP); 
END; 
/ 
