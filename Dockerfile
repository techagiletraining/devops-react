FROM node:latest

# The base node image sets a very verbose log level.
ENV NPM_CONFIG_LOGLEVEL warn

# Install `serve` to run the application.
RUN npm install -g serve

# Install all dependencies of the current project.
COPY package.json package.json
RUN npm install

COPY . .

# Build for production
RUN npm run build --production

# Run serve when the image is run.
CMD serve -s build

# Let Docker know about the port that serve runs on.
EXPOSE 5000