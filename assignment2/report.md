Best viewable in https://dillinger.io/

# Method
```
for each block b in ast:
        bucket = countStatements(b)
        addBlock(hash, key, b)

for each block i and j in the same bucket:
        if compareBlocks(i, j):
                for each subBlock s in i:
                        if s in clones:
                                removeClonePair(clones, s)

        addClonePair(clones, i, j)
```

# how to use

## Prerequisites

- Nodejs 8 or higher
- Python version 2 or 3
- Eclipse + Rascal plugin

## Show me the visualization results

```
cd visualization
npm install
npm start
```
Navigate your browser to localhost:4200

## Generate new visualization results

Open rascal project assignment2

```
import clone_detection;
import lang::java::jdt::m3::AST;
a = createAstsFromEclipseProject(|project:///example|, true);
clones(a);
```

Open a command window to convert rascal output to json
```
python clonesToWheel.py clones.txt ../visualization/src/clonesWheel.json
python clonesToTreemap.py clones.txt ../visualization/src/clonesTreemap.json
```

Save the resulting text file and run it through test.py
Use the resulting json file and put it in flare.json
Install nodejs 8 or higher
```
npm install
npm start
```

Open a webbrowser and go to localhost:4200

## Generate metrics

Open rascal project assignment2

```
import clone_detection;
import lang::java::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;
a = createAstsFromEclipseProject(|project:///example|, true);
m = createM3FromEclipseProject(|project:///example|);
getMetrics(a, m);
```

# Metrics Results

## smallsql0.21_src

```
rascal>getMetrics(a, m);
Code clone type-1:
Number of clones:               148
Number of clone classes:        88
Biggest clone class:            <11,|project://smallsql0.21_src/src/smallsql/database/IndexScrollStatus.java|(4128,400,<120,33>,<131,41>)>
Number of cloned lines:         561
Percentage of cloned lines:     2.332640333%

First two clone classes:
<|project://smallsql0.21_src/src/smallsql/database/Money.java|(2032,97,<67,58>,<71,5>),1,"{\r\n        Money money = new Money();\r\n        money.value = value;\r\n        return money;\r\n    }">

<|project://smallsql0.21_src/src/smallsql/database/ExpressionFunctionUCase.java|(1679,80,<52,41>,<55,2>),1,"{\r\n        if(isNull()) return null;\r\n        return getString().getBytes();\r\n\t}">

Code clone type-2:
Number of clones:               882
Number of clone classes:        180
Biggest clone class:            <23,|project://smallsql0.21_src/src/smallsql/junit/TestOrderBy.java|(19300,752,<729,57>,<757,2>)>
Number of cloned lines:         1945
Percentage of cloned lines:     8.087318087%

First two clone classes:
<|project://smallsql0.21_src/src/smallsql/database/Money.java|(1873,97,<61,59>,<65,5>),1,"{\r\n        Money money = new Money();\r\n        money.value = value;\r\n        return money;\r\n    }">

<|project://smallsql0.21_src/src/smallsql/database/ExpressionFunctionDayOfYear.java|(1597,139,<48,37>,<52,2>),1,"{\r\n\t\tif(param1.isNull()) return 0;\r\n\t\tDateTime.Details details = new DateTime.Details(param1.getLong());\r\n\t\treturn details.dayofyear+1;\r\n\t}">

ok
```

## hsqldb

```
getMetrics(a2, m2)
Code clone type-1:
Number of clones:               3952
Number of clone classes:        772
Biggest clone class:            <70,|project://hsqldb/src/org/hsqldb/server/Servlet.java|(9474,4474,<245,60>,<344,5>)>
Number of cloned lines:         8703
Percentage of cloned lines:     5.046797258%

First two clone classes:
<|project://hsqldb/integration/hibernate/src/org/hibernate/dialect/HSQLDialect.java|(13357,846,<250,68>,<266,9>),1,"{\n                if ( hsqldbVersion \< 20 ) {\n                        return new StringBuffer( sql.length() + 10 )\n                                        .append( sql )\n                                        .insert(\n                                                        sql.toLowerCase().indexOf( \"select\" ) + 6,\n                                                        hasOffset ? \" limit ? ?\" : \" top ?\"\n                                        )\n                                        .toString();\n                }\n                else {\n                        return new StringBuffer( sql.length() + 20 )\n                                        .append( sql )\n                                        .append( hasOffset ? \" offset ? limit ?\" : \" limit ?\" )\n                                        .toString();\n                }\n        }">

<|project://hsqldb/src/org/hsqldb/test/TestLobs.java|(17352,369,<530,43>,<539,13>),1,"{\n                reader = dataClob.getCharacterStream();\n\n                ps.setString(1, \"test-id-1\" + i);\n                ps.setLong(2, 23456789123456L + i);\n                ps.setCharacterStream(3, reader, dataClob.length());\n                ps.setString(4, \"test-scope-1\" + i);\n                ps.executeUpdate();\n                connection.commit();\n            }">

Code clone type-2:
Number of clones:               5802
Number of clone classes:        1682
Biggest clone class:            <82,|project://hsqldb/src/org/hsqldb/dbinfo/DatabaseInformationMain.java|(132183,4390,<3209,73>,<3312,5>)>
Number of cloned lines:         20890
Percentage of cloned lines:     12.11393712%

First two clone classes:
<|project://hsqldb/src/org/hsqldb/test/TestSql.java|(31289,323,<909,30>,<923,5>),1,"{\n\n        try {\n            stmnt.execute(\"SHUTDOWN\");\n\n            if (!isNetwork) {\n                connection.close();\n            }\n        } catch (Exception e) {\n            e.printStackTrace();\n            System.out.println(\"TestSql.tearDown() error: \" + e.getMessage());\n        }\n\n        super.tearDown();\n    }">

<|project://hsqldb/src/org/hsqldb/test/TestLobs.java|(2951,249,<86,12>,<93,9>),6,"{\n            String ddl0 = \"DROP TABLE BLOBTEST IF EXISTS\";\n            String ddl1 =\n                \"CREATE TABLE BLOBTEST(ID IDENTITY, BLOBFIELD BLOB(100000))\";\n\n            statement.execute(ddl0);\n            statement.execute(ddl1);\n        }">
```

## tests

To run our test suite, import clone_tests and run :test in a console.

Results:

```
Running tests for clone_tests
Test report for clone_tests                                                               
        all 5/5 tests succeeded
bool: true
```

# Design decisions

# threats to validity

# time taken

- Michael: 40 hours
- Constantijn: 60 hours

# References

I. D. Baxter, A. Yahin, L. Moura, M. Sant'Anna and L. Bier, "Clone detection using abstract syntax trees," Proceedings. International Conference on Software Maintenance (Cat. No. 98CB36272), Bethesda, MD, 1998, pp. 368-377.
doi: 10.1109/ICSM.1998.738528
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=738528&isnumber=15947

Chanchal K. Roy, James R. Cordy, Rainer Koschke, Comparison and evaluation of code clone detection techniques and tools: A qualitative approach, In Science of Computer Programming, Volume 74, Issue 7, 2009, Pages 470-495, ISSN 0167-6423, DOI: https://doi.org/10.1016/j.scico.2009.02.007.
URL: http://www.sciencedirect.com/science/article/pii/S0167642309000367

Lingxiao Jiang, Ghassan Misherghi, Zhendong Su, and Stephane Glondu. 2007. DECKARD: Scalable and Accurate Tree-Based Detection of Code Clones. In Proceedings of the 29th international conference on Software Engineering (ICSE '07). IEEE Computer Society, Washington, DC, USA, 96-105. DOI=http://dx.doi.org/10.1109/ICSE.2007.30
URL: https://dl.acm.org/citation.cfm?id=1248843
