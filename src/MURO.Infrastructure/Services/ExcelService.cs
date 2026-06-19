using ClosedXML.Excel;
using MURO.Application.Interfaces;
using System.Reflection;

namespace MURO.Infrastructure.Services;

public class ExcelService : IExcelService
{
    public byte[] ExportToExcel<T>(IEnumerable<T> data, string sheetName = "Sheet1")
    {
        using var workbook = new XLWorkbook();
        var worksheet = workbook.Worksheets.Add(sheetName);

        var properties = typeof(T).GetProperties();
        for (int i = 0; i < properties.Length; i++)
        {
            worksheet.Cell(1, i + 1).Value = properties[i].Name;
            worksheet.Cell(1, i + 1).Style.Font.Bold = true;
        }

        var row = 2;
        foreach (var item in data)
        {
            for (int col = 0; col < properties.Length; col++)
            {
                var val = properties[col].GetValue(item);
                worksheet.Cell(row, col + 1).Value = val?.ToString();
            }
            row++;
        }

        worksheet.Columns().AdjustToContents();

        using var stream = new MemoryStream();
        workbook.SaveAs(stream);
        return stream.ToArray();
    }

    public List<T> ImportFromExcel<T>(Stream stream) where T : new()
    {
        var list = new List<T>();
        using var workbook = new XLWorkbook(stream);
        var worksheet = workbook.Worksheet(1); // Assume the first sheet
        var properties = typeof(T).GetProperties();

        var headerRow = worksheet.Row(1);
        var headers = new Dictionary<string, int>();

        // Map column headers to their 1-based index (scan all used columns or at least properties length)
        var lastColumn = worksheet.LastColumnUsed();
        var lastCol = Math.Max(properties.Length, lastColumn != null ? lastColumn.ColumnNumber() : 10);
        for (int i = 1; i <= lastCol; i++)
        {
            var cellValue = headerRow.Cell(i).GetString()?.Trim();
            if (!string.IsNullOrEmpty(cellValue))
            {
                headers[cellValue.ToLower()] = i;
            }
        }

        var rows = worksheet.RangeUsed().RowsUsed().Skip(1); // Skip header row
        foreach (var row in rows)
        {
            var item = new T();
            bool hasData = false;

            foreach (var property in properties)
            {
                var pName = property.Name.ToLower();
                int colIndex = -1;

                // 1. Try exact match
                if (headers.TryGetValue(pName, out int idx))
                {
                    colIndex = idx;
                }
                else
                {
                    // 2. Try cleaned match (strip spaces, dots, dashes, underscores)
                    var cleanedProp = pName.Replace(".", "").Replace(" ", "").Replace("-", "").Replace("_", "");
                    var matchedKey = headers.Keys.FirstOrDefault(k => k.Replace(".", "").Replace(" ", "").Replace("-", "").Replace("_", "") == cleanedProp);
                    if (matchedKey != null)
                    {
                        colIndex = headers[matchedKey];
                    }
                    else
                    {
                        // 3. Turkish synonyms fallback for known properties
                        string? fallbackKey = null;
                        if (cleanedProp == "ad")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "adi" || k == "adı");
                        else if (cleanedProp == "soyad")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "soyadi" || k == "soyadı");
                        else if (cleanedProp == "telefon")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "telefonu" || k == "tel" || k == "telno" || k == "telefonno" || k == "telefonnumarası" || k == "telefonnumarasi");
                        else if (cleanedProp == "tc")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "tckimlik" || k == "tckimlikno" || k == "tckimliknumarası" || k == "tckimliknumarasi" || k == "tcno" || k == "tckimlikno");
                        else if (cleanedProp == "rol")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "rolü" || k == "rolu");
                        else if (cleanedProp == "eposta")
                            fallbackKey = headers.Keys.FirstOrDefault(k => k == "email" || k == "mail" || k == "e-posta");

                        if (fallbackKey != null)
                        {
                            colIndex = headers[fallbackKey];
                        }
                    }
                }

                if (colIndex != -1)
                {
                    var cell = row.Cell(colIndex);
                    var cellValue = cell.GetString()?.Trim();
                    
                    if (!string.IsNullOrEmpty(cellValue))
                    {
                        hasData = true;
                        try
                        {
                            var targetType = Nullable.GetUnderlyingType(property.PropertyType) ?? property.PropertyType;
                            var convertedValue = Convert.ChangeType(cellValue, targetType);
                            property.SetValue(item, convertedValue);
                        }
                        catch
                        {
                            // If conversion fails, ignore for this simple implementation
                        }
                    }
                }
            }

            if (hasData)
            {
                list.Add(item);
            }
        }

        return list;
    }

    public byte[] GenerateTemplate<T>(string sheetName = "Template")
    {
        using var workbook = new XLWorkbook();
        var worksheet = workbook.Worksheets.Add(sheetName);

        var properties = typeof(T).GetProperties();
        for (int i = 0; i < properties.Length; i++)
        {
            worksheet.Cell(1, i + 1).Value = properties[i].Name;
            worksheet.Cell(1, i + 1).Style.Font.Bold = true;
        }

        worksheet.Columns().AdjustToContents();

        using var stream = new MemoryStream();
        workbook.SaveAs(stream);
        return stream.ToArray();
    }
}
