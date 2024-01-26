# Table-view
Generating an html file with a table based on aggrid. 

# Usage
the show function returns the name of the generated file:

```
show(table, filter=[], resize=true, outFile="./result/index.html")
```
the argument filter accepts a list of parameters for the filter SideBar:
```
filters = ["ColumnName1", "ColumnName1", "ColumnName1", "cols"]
```
where cols is responsible for filtering by included columns.

