Showerify 
===

## Shower Smart, Save Water
### By Shreya Vinjamuri
#### Meta University 2022

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Showerify is an app that gamifies saving water where users improve their shower time with their Spotify playlist and a voice-enabled smart timer. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Environmental
- **Mobile:** This app will primarily be developed in mobile, but may be viable for a website in the future.  
- **Story:** Users start by setting a goal for how long they want to shower ranging from 2 to 11 minutes. Then, they can set a timer or sync their spotify music to time their showers. They can see the progress they are making and adjust their goal. Users can also create personalized routines and connect with friends.
- **Market:** The target audience is for anyone who wants to save water in the shower.
- **Habit:** The user should ideally open the app anytime they take a shower and either start their playlist or a timer to keep track of their shower time.
- **Scope:** The core features of the application include allowing users to time their showers in 3 different ways (timer, music, routine), seeing their previous showers, increasing their bubblescore everytime they meet their goal, seeing a leaderboard and their impact.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] Users can make an account and log in
- [x] Users can set a profile picture
- [x] Users can set a goal: target 2 min to 11 min
- [x] User can start a stopwatch set to their goal to time themselves
- [x] If timer goes down, it has to start counting up again
- [x] User can connect with spotify sdk to play music → timer times this and when they stop, they can save their progress
- [x] Users can see a list of their saved showers
- [x] Each user will have a bubblescore, which is a number that shows how many times they’ve met their goal
- [x] Users can see a streak of how many times they met their goal in a row
- [x] Users can see a leaderboard of scores
- [x] Users can see an impact page with an animation outlining their impact and some statistics 
    - [x] impact page: user can enter their average water flow or choose to use the national average and then input the number of times they shower each week-> number of gallons per week and number of gallons per year will be shown
    - [x] The calculations will be redone but with reducing your shower time by one minute to see how much water you can save if you reduce shower time by 1/10 of your average shower time


**Optional Nice-to-have Stories**

- [x] Users can connect with other friends 
- [x] Users can the profiles of other friends
* Users can schedule shower races with friends
- [x] Users can personalize a routine and time their routine in the shower
- [x] Users can hear voice countdowns
* Users can see a calendar of all the dates that the user met their goal in green


### 2. Screen Archetypes

* Log in screen
   * Users are able to login from the application
* Register screen
   * Users are able to sign-up from the application
* Home screen
   * Users can set a goal, see their average stats, and see their bubblescore and streak
   * Users can see their friends
* Timer
   * Timer + Music: Users can connect their Spotify account and start a timer (with voice countdowns) simultaneously when they're about to shower
   * Timer: Users can start a stopwatch with voice countdowns at minute intervals when they're about to shower
   * Routine: Users can create a routine and start a timer while going through their routine
* Showers screen
    * Users can see a list of their saved showers
* Impact Screen
    * Users can see their impact and some important facts about saving water in the shower
* Explore screen
    * Users can find other friends and see their profiles / stats
* Leaderboard screen
    * Users can see a leaderboard of who has the highest bubblescores across all the users in the app

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home screen
* Timer Screen
* Showers Screen
* Explore Screen
* Leaderboard Screen

**Flow Navigation** (Screen to Screen)

* Login
    * -> Home Screen
* Home Screen
    * -> Settings Screen
    * -> Logout Screen
* Timer Screen
    * -> Timer + Music Screen
    * -> Timer Screen
    * -> Routine Screen
* Showers Screen
    * -> Impact Screen
* Explore Screen
    * -> Details Screen (for each person)
* Leaderboard Screen
    * -> Details Screen (for each person)

## Wireframes
[Add picture of your hand sketched wireframes in this section]
![](https://i.imgur.com/lU3L7lv.jpg)

### [BONUS] Digital Wireframes & Mockups

LINK TO FIGMA:
https://www.figma.com/file/UCKmBN8lOQ5Od3bav4RI8Q/Shower-App-Final?node-id=0%3A1

### [BONUS] Interactive Prototype


## Schema 
### Models


Model 1: Shower
| Property | Type | Description |
| -------- | -------- | -------- |
| date     | date     | date of shower (month, day, year)     |
| length | DateTime | length of shower |
| metGoal | boolean | whether the goal was met or not |
| goal | DateTime | goal set at the time of the shower |
| User | pointer to User | user that saved the shower |


Model 2: User
| Property | Type | Description |
| -------- | -------- | -------- |
| username     | String     | username used to login|
| password | String | password used to login |
| profilePic | File | user's profile pic |
| objectId | String | unique id for user |
| currentGoal | DateTime | user's current set goal |
| bubbleGoal | Number | user's bubblescore (# of times their goal is met) |
| streak | Number | user's streak (# of times goal is met consecutively) |

Model 3: Routine
| Property | Type | Description |
| -------- | -------- | -------- |
| title     | String     | name of step in routine|
| objectId | String | unique id for routine |
| time | Number | number of seconds the step in the routine takes |
| User | pointer to User | user that saved the routine |


### Networking

* Home Screen
    * GET --> username, profile picture, bubblescore, streak, set goal
* All Timer Screens
    * POST --> saving a shower
* Routin Screen
   * GET --> current routine
   * POST --> updates to routine
* Showers Screen
    * GET --> retrieving all the showers associated with the current user
* Explore Screen
   * GET --> all the other users that the current user is not friends with
* Leaderboard Screen
    * GET --> from all the users, getting the users with the highest bubblescores


![](https://i.imgur.com/qzgrfLO.jpg)
