## 23VT-4ME307 Internet Architectures

## Note Nirvana - a Note Taking App
Note Nirvana is a web-based note-taking app that helps you stay organized and on top of your ideas. 
With a sleek and intuitive interface, Note Nirvana makes it easy to create, edit, and manage your notes from anywhere.
## Key Features
- **Create and Edit Notes:** Quickly create new notes and edit existing ones using a simple, user-friendly interface.
- **Organize Your Notes:** Sort and categorize your notes by tags, folders, and dates to stay on top of your ideas and projects.
- **Search and Filter:** Easily find notes by searching for keywords or filtering by tags, folders, or dates.
- **Collaborate:** Share notes with colleagues or friends for seamless collaboration on projects and ideas.
- **Customize Your Experience:** Choose from a range of customizable themes and layouts to make Note Nirvana your own.

## Group Members: (Group - 6)
1. Prasannjeet Singh
2. Dennis Demir
3. Sudeesh Sukumara Pillai
4. Gauthem Krishna

### Steps to run the application
1. The `frontend` folder contains the code for the frontend of the application. The frontend is built using ReactJS. To run the frontend, follow the steps below:
    1. Open the terminal and navigate to the `frontend` folder.
    2. Run the command `npm install` to install all the dependencies.
    3. Run the command `npm start` to start the frontend server.
    4. The frontend server will start on port 3000. Open the browser and navigate to `http://localhost:3000` to view the frontend.
2. The `backend` folder contains the code for the backend of the application. The backend is built using Spring Framework. To run the backend, follow the steps below:
    1. Open the terminal and navigate to the `backend` folder.
    2. Run the command `mvn clean install` to build the backend. It will build the application and create a docker image.
    3. Run the command `docker-compose up` to start the backend server.

### Assignment - 1 : Develop a Web Application
#### Part 1: Design your web application
- Explain the purpose of the application
- Use the theory for web application architectures to explain your design.
- Minimum: include a module that executes the application goal, a module for permanent storage of data, a module for HTML rendering.
  - You choose the web application purpose
  - You choose the technologies used
  - You choose the HTML rendering on the client side or server side.
- Explain the design in a document of 3 pages length maximum
#### Part 2: Implement your web application
- You must be able to deploy all the modules proposed for your web application in Part 1 on your own computer
  - The users will connect to localhost, and the modules can use localhost to communicate between them. 
  - The users will connect to http://localhost:8080
- All the code should be in a single repository in GitLab.lnu.se
  - The root folder of the repository must contain a README file with instructions to install your application.
- To get a grade A or B, you must implement some more advanced features. It is your choice. Some examples:
    - Use more than one database for the persistent storage
    - Distribute the application API module into sub-modules that can be independently deployed on your computer
    - Implement asynchronous communication between modules (message queueing RabbitMQ)
    - Implement access through https instead of http
    - Keep user session
#### Deliverables
- A document on mymoodle with a pdf that includes:
    - 3-page architectural description for part 1
    - The link to your repository in GitLab
    - Give maintainer permissions to Jesper and me (dipeab)
    - Only one submission per group!
- Deadline: April 14th
- A 10-minute presentation where you explain the architecture and show a demo of your web application

