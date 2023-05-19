const express = require("express");
const casual = require("casual");
const starWarsPlanets = [
  "Alderaan",
  "Ando Prime",
  "Coruscant",
  "Dagobah",
  "Endor",
  "Geonosis",
  "Hoth",
  "Jakku",
  "Kashyyyk",
  "Naboo",
  "Tatooine",
  "Yavin 4",
];
const starWarsCharacters = [
  "Luke Skywalker",
  "Leia Organa",
  "Han Solo",
  "Darth Vader",
  "Emperor Palpatine",
  "Yoda",
  "Obi-Wan Kenobi",
  "Chewbacca",
  "R2-D2",
  "C-3PO",
];

const app = express();

app.get("/healthz", (req, res) => {
  console.log("GET /healthz");
  res.send("OK");
});

app.get("/livez", (req, res) => {
  console.log("GET /livez");
  res.send("OK");
});

app.get("/invoices", (req, res) => {
  const invoices = [];
  for (let i = 0; i < 25; i++) {
    const invoiceNumber = casual.uuid;
    const planet =
      starWarsPlanets[casual.integer(0, starWarsPlanets.length - 1)];
    const customer =
      starWarsCharacters[casual.integer(0, starWarsCharacters.length - 1)];
    const totalAmount = casual.price;
    const dueDate = casual.date;

    invoices.push({
      invoiceNumber,
      planet,
      customer,
      totalAmount,
      dueDate,
    });
  }
  console.log("GET /invoices");
  res.json(invoices);
});

app.listen(3000, () =>
  console.log("🚀 invoice service listening on port 3000!")
);
