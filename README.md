# text-assessment

## Project deployment

To deploy the project, you need to perform the following steps:
1. Clone this repository.
2. Open terminal and go to the root folder of the project.
3. Compile the project with the 
   ```haskell
   stack build
   ```
   command.
4. Open file **config.json** in root folder of the project and fill up your values
5. Run the server with the 
   ```haskell
   stack run
   ```
   command from the root folder of the project.
6. Open one more terminal to send requests to the server or use browser.


## Examples of requests to the server

```
curl -X GET 'http://localhost:8080/London+is+the+capital+of+Great+Britain'
```
```
curl -X GET 'http://localhost:8080/Unse+apone+a+time'
```
```
curl -X GET 'http://localhost:8080/превет+каг+тваи+дела'
```
```
curl -X GET 'http://localhost:8080/Голодное+море+шипя+поглотило+осенее+Солнце'
```
```
curl -X GET 'http://localhost:8080/There+is+a+hause+in+New+Orleans'
```

