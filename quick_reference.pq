/*
Copyright 2020 Anthony Hawkes

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

================================================================================
* @File Name          : quick_reference.pq
* @Author Contact     : foss@malphas.io
* @Created Date       : 2020-03-30
* @Last Modified Date : 2020-03-30
* @Comments           : N/A
* @TODO               : N/A
================================================================================
*/

// Rename columns in Table.
NewTable = Table.RenameColumns(SourceTable, {{"Original Name", "New Name"}, {"Extra Column Original Name", "New Name"}})

// Filter rows.
NewTable = Table.SelectRows(SourceTable, each ([Column Name] = "Filter Value"))

// Select specific columns.
NewTable = Table.SelectColumns(SourceTable, {"Column1", "Column2", "Column3"})

// Select distinct rows.
NewTable = Table.Distinct(SourceTable, "TargetColumn")

// Select distinct columns together rows.
NewTable = Table.Distinct(SourceTable, {"TargetColumn1", "TargetColumn2"})

// Remoove rows with null value.
NewTable = Table.SelectRows(SourceTable, each not ([Column] = null))

// Remove rows matching value.
NewTable = Table.SelectRows(SourceTable, each not ([Column] = "Value to Remove"))

// Select rows matching valuye.
NewTable = Table.SelectRows(SourceTable, each ([Column] = "Value to Select"))

// Example function. 
Output = (input1, input2) =>
    let
        // Do something
        TableOutput = "D"
    in
        TableOutput,
TypeOfOutput = Output(in1,in2)

// Expand nested.
NewTable = Table.ExpandTableColumn(SourceTable, "SourceColumn", {"NestedColName1", "NestedColName2"}, {"NewColName1", "NewColName2"})

// Add column with values based on conditional logic.
NewTable = Table.AddColumn(SourceTable, "NewColumnName", each if [SomeOtherCol] = 1 then "Value1" else if [SomeOtherCol] = 2 then "Value2" else "Not Known")

// Change column type.
NewTable = Table.TransformColumnTypes(SourceTable,{{"Column1", Int64.Type}, {"Column2", type logical}})

// Convert 0/1 string to bool.
NewTable1 = Table.TransformColumnTypes(SourceTable,{{"Column", Int64.Type}}),
NewTable2 = Table.TransformColumnTypes(NewTable1,{{"Column", type logical}})

// Get only hostname of FQDN
Table.SplitColumn(SourceTable, "HostnameField", Splitter.SplitTextByDelimiter(".", QuoteStyle.Csv), {"HostnameField"})

// Date Range to Table with Column of Days between range.
// TYPE: source_date type Date.Type, destination_date type Date.Type.
date_range_by_day_table_generator = (source_date, destination_date) =>
    let
        source_date_to_int = Int32.From(source_date),
        destination_date_to_int = Int32.From(destination_date),
        date_range_list_int = {source_date_to_int..destination_date_to_int},
        date_range_list_int_to_table = Table.FromList(date_range_list_int,Splitter.SplitByNothing(), {"Date"}),
        date_to_int = Table.TransformColumnTypes(date_range_list_int_to_table,{{"Date", Int32.Type}}),
        date_to_date = Table.TransformColumns(date_to_int,{"Date", Date.From})
    in
        date_to_date,
date_range_table = date_range_by_day_table_generator(date_from, date_to)

// Minimum date from column.
Value = Date.From(List.Min(Table.Column(SourceTable, "Column"))),

// Get Now as DateTimeZone.
Value = DateTimeZone.LocalNow()

// Get Now date as DateTime.
Value = DateTime.LocalNow()

// Get Now date as Date.
Value = Date.From(DateTime.LocalNow())

// Generate series as list.
List = {1..10}

// List to table assuming comma seperation.
Table.FromList(SourceList)
// List to table with only one column.
Table.FromList(SourceList, Splitter.SplitByNothing())
// List to table with custom delimiter. Example |.
Table.FromList(SourceList, Splitter.SplitTextByDelimiter("|"))
// List to table with custom column names.
Table.FromList(SourceList, Splitter.SplitTextByDelimiter(","), {"Column1", "Column2"})

// Type conversions.
Value = Number.FromText(value)
Value = Number.ToText(value)
Value = Number.From(value)
Value = Int32.From(value)
Value = Int64.From(value)
Value = Single.From(value)
Value = Double.From(value)
Value = Decimal.From(value)
Value = Currency.From(value)
Value = Text.From(value)
Value = Logical.FromText(value)
Value = Logical.ToText(value)
Value = Logical.From(value)
Value = DateTime/Date/DateTimeZone.FromText(value)
Value = DateTime/Date/DateTimeZone.ToText(value)
Value = DateTime/Date/DateTimeZone.From(value)
Value = DateTime/Date/DateTimeZone.ToRecord(value)

// Return true if All Values Exist in Table Tab - useful for checking a value exists for a key with multiple rows.
NewTable = Table.ContainsAll(ForeignTable, { [ForeignKey1="String Filter", ForeignKey2= "String Filter"]})

// New Column if Match in Foreign Table Using Key From Current Table
NewTable = Table.AddColumn(SourceTable, "New Column Name", each if Table.ContainsAll(ForeignTable, { [ForeignKey1=[SourceKey], ForeignKey2= "String Filter"]}) then "Some Value When True" else "Some Value if False")

// Last position in table. (not tested)
Value = Table.PositionOf(SourceTable, Table.Last(SourceTable))

// Insert row at position. 0 (first) in example.
NewTable = Table.InsertRows(SourceTable, 0, {[Col1 = 3, Col2 = "Value", Col3 = "Value"]})

// Insert multiple rows starting at position. 0 (first) in example.
NewTable = Table.InsertRows(SourceTable, 0, {[Col1 = 3, Row1Col2 = "Row1Value", Col3 = "Row1Value"], [Col1 = 3, Row1Col2 = "Row2Value", Col3 = "Row2Value"]})

// Remove empty columns.
remove_blank_cols = (input) =>
    let
        column_names =  Table.ColumnNames(input),
        // EXPLANATION: Iterate over each column name (from column_names), 
        // select each column from table (input), and count each non null field. 
        // If the total count is > 0 select otherwise ignore.
        non_empty = List.Select(column_names, each List.NonNullCount(Table.Column(input, _)) > 0 ),
        return = Table.SelectColumns(input, non_empty)
    in
        return,
NewTable = remove_blank_cols(SourceTable)
