/** @format */
// npm i -g pm2
// pm2 start command.js
/** @format */

const http = require("http");
const qs = require("querystring");
const { exec } = require("child_process");

const USERNAME = "YOUR_SETCRET";
const AUTH_STRING =
  "Basic " + Buffer.from(`${USERNAME}:${USERNAME}`).toString("base64");

const server = http.createServer((req, res) => {
  // 認証のチェック
  const auth = req.headers["authorization"];
  if (!auth || auth !== AUTH_STRING) {
    res.writeHead(401, { "WWW-Authenticate": 'Basic realm="Secure Area"' });
    res.end("Unauthorized");
    return;
  }

  if (req.method === "GET") {
    // GETリクエスト時にフォームを表示
    res.statusCode = 200;
    res.setHeader("Content-Type", "text/html; charset=utf-8");
    res.end(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Input Form</title>
      </head>
      <body>
        <form id="inputForm">
          <input type="text" id="inputText" name="inputText" style="width:500px; height:100px;"></input>
          <button type="submit">Submit</button>
        </form>
        <p><a href="https://minecraftbedrock-archive.fandom.com/wiki/Commands/List_of_Commands">ref</a></p>
        <script>
          document.getElementById("inputForm").addEventListener("submit", async function(event) {
            event.preventDefault();
            const inputText = document.getElementById("inputText").value;
            const response = await fetch("/", {
              method: "POST",
              headers: {
                "Content-Type": "application/x-www-form-urlencoded"
              },
              body: new URLSearchParams({ inputText: inputText })
            });
            if (response.ok) {
              alert("Submitted successfully!");
            } else {
              alert("Failed to submit!");
            }
          });
        </script>
      </body>
      </html>
    `);
  } else if (req.method === "POST") {
    // POSTリクエスト時に文字列を受け取りログに出力
    let body = "";
    req.on("data", (chunk) => {
      body += chunk.toString();
    });
    req.on("end", () => {
      const parsedBody = qs.parse(body);
      const inputText = parsedBody.inputText;

      console.log(`Received text: ${inputText}`);
      exec(
        `screen -p 0 -X stuff "${inputText}$(printf \r)"`,
        (err, stdout, stderr) => {
          console.log("error", err);
        }
      );
      res.writeHead(200, { "Content-Type": "text/plain" });
      res.end("Received\n");
    });
  } else {
    res.statusCode = 405;
    res.setHeader("Content-Type", "text/plain");
    res.end("Method Not Allowed\n");
  }
});

server.listen(8888, "0.0.0.0", () => {
  console.log("Server running at http://0.0.0.0:8888/");
});
