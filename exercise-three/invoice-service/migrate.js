const { Client } = require("pg");

const client = new Client({
  host: "invoice-db",
  port: 5432,
  user: "invoice_user",
  database: "postgres",
  password: process.env.DATABASE_PASSWORD || "default",
});

client.connect();

console.log("🔧 Running Migrations");

console.log("Reading from process.env.DATABASE_PASSWORD");

client.query(
  `
CREATE TABLE IF NOT EXISTS invoices (
  uuid VARCHAR(36) NOT NULL,
  planet VARCHAR(255) NOT NULL,
  customer VARCHAR(255) NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  due_date DATE NOT NULL,
  PRIMARY KEY (uuid)
);
`,
  [],
  (err, res) => {
    console.log(err ? err.stack : res); // Hello World!
    client.end();
    console.log("👍 Migrations complete");
  }
);
