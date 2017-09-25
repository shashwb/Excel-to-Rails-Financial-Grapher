# Financial Data Tracker - Excel


1. This project uses ruby 2.4.1 and is configued to use rvm, but feel to use whichever version manager you prefer.
2. `git clone https://github.com/shashwb/Excel-to-Rails-Financial-Grapher.git`
3. Navigate to the proper directory
3. run `bundle install` to install all gems necessary for server
4. `rake db:create && rake db:migrate` to set up the database. Call `rake db:reset` to flush and repopulate database
5. Finally, run `rails s` or `rails server` to run the local server
6. load `http://localhost:3000` for the index. The actual application is located at `http://localhost:3000/importer`
7. Application is running!



## Description

Rails application for analyzing complex financial datasets with statistical methods including regression, linear line models, R and R^2 values and Beta. The user can input their own Excel or Google Spreadsheets data and the applciation backend will parse it into the database as long as it fits the | `:date` | `:category` | `data` | model. A sample input is provided within the project (/"testdata.xlsx").

- Front End technology will be expanded upon for optimal speed and to cut back on heavy front-end processing. Currently runs on a Bootstrap framework.

- Back End technology will be moved from Ruby on Rails to Django to utilize the 'Pandas' and 'Numpy' libraries for statistical analysis.

Importer path contains overall graph of default data that can be indexed by time and compared individually. 

Grapher path contains overall graph from database values (custom data from user) as well as statistical analysis through HighCharts and proprietary statistical backend logic.



