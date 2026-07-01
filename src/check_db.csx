#r "nuget: Npgsql, 8.0.2"
using System.IO;
using System.Text.Json;
using Npgsql;
using System;

string connStr = "Host=localhost;Port=5432;Database=muro_dev;Username=muro_user;Password=muro_pass_2024;";
using var conn = new NpgsqlConnection(connStr);
conn.Open();

using var cmd = new NpgsqlCommand("SELECT \"UserId\", SUM(\"WatchedSeconds\") as t FROM \"VideoProgresses\" GROUP BY \"UserId\" ORDER BY t DESC LIMIT 10;", conn);
using var reader = cmd.ExecuteReader();
while (reader.Read()) {
    Console.WriteLine($"{reader[0]} -> {reader[1]} secs");
}
