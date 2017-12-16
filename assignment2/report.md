Best viewable in https://dillinger.io/

# Method
The algorithm used for clone detection is based on the paper Clone Detection Using Abstract Syntax Trees[1]. We chose this algorithm because it is easy to work with abstract syntrax trees in RASCAL. Additionally, we focussed on type-1 and type-2 clones which are easy to find using abstract syntax trees, especially in RASCAL if you remove source locations using ```unsetRec```.

The algorithm works by comparing subtrees. This is done by first hashing subtrees to a bucket. In our implentation we use ```block``` statements instead because these contain lists of statements which essentially are a subtree. The number of statements for each block is first counted so that blocks with the same number of statements are hashed in the same bucket. This saves performance later on when blocks are compared, because for type-1 and type-2 clones the number of statements has to be exactly the same. This also allows us to easily set a minimum and maximum for the number of statements which means we can easily adjust the size of the clones we want to detect.

After the hashing has been completed, we go over each pair within the same bucket and check if they are the same by simply comparing for exact equality. The algorithm in the paper uses a formula the calculate the similarity between two subtrees. A function to calculate this similarity has been implemented but it only added 12 new clones with a threshold as low as 0.5 and these clones were of type-3. It is expected that this formula would add type-3 clones because it uses the number of shared and different nodes to calculate the similarity. Since the focus of our clone detection was to detect type-1 and type-2 clones, we have opted to just check for exact equality.

Once a clone pair is found by comparing for exact equality, a list of all the blocks in one of the found clones is created. If one of these blocks is in the set of clone pairs that have been gathered so far, it is then removed so that only the largest form of the clone ends up in the set of clone pairs. Once it is done checking for subblocks the new clone pair is added to the set of clones.

```
for each block b in ast:
        bucket = countStatements(b)
        addBlock(hash, bucket, b)

for each block i and j in the same bucket:
        if compareBlocks(i, j):
                for each subBlock s in i:
                        if s in clones:
                                removeClonePair(clones, s)

                addClonePair(clones, i, j)
```

In order to detect type-2 clones an additional step needs to be taken. This step changes the abstract syntax tree such that identifiers, literals and types are ignored when checking for equality. This is done by replacing the value of these to the same value. Each of the identifiers has their value changed to an empty string, each literal is changed to the boolean literal for true and each type is changed to that of boolean. So now when the subtrees are compared for exact equality these values are the same and thus will go through the equality check.

```
// type replacer
visit (ast):
    case \int()     => \boolean()
    case \short()   => \boolean()
    ...
    case \void()    => \boolean()
```

# *Visualization*

For visualizing code clones, we implemented two visualizations: the Treemap and the Hierachical Tree Bundling (HTB). The Treemap is to be used for interactivity and an overview of all code clones and the HTB is used for a high level view.

## Treemap

The Treemap both shows the maintainer which code clones belong to the same code clone class and is interactive by pointing the maintainer to the correct code clone source lines on clicking one of the blocks.

### Main requirements satisfying maintainer

The following categories come from [4] and aim to identify the areas in which the chosen visualization improves the usability for a maintainer.

E8: navigation is improved by providing a means of navigating between code clone classes and its source code
E11: The maintainer is focussed by the grouping of code clone classes through colours and is led to the same textual representation when clicking on the specific clone
E13: New nodes for searching are reached through the display of filenames upon hovering on the item
E14: visualization is static and therefore the maintainer is not burdened by any UI adjustments

## Hierachical Tree Bundling (HTB)

The HTB provides a high level view of which files contain clones from other files or if the file contains code clones but contained just within the same file. When a file contains code clones but has all are contained within the same file, it is shown as a filename with no links to any other. Files that do have links to other files might contain clones of itself within itself, but to reduce the clutter of the visualization, we opted to not show links to the same file, effectively obscuring these types of clones in this particular visualization. However, the Treemap visualization does show these types.

### Main requirements satisfying maintainer

E11: The maintainer is focussed by the indication of which files are linked to each other through code clone classes.
E13: New nodes for searching are reached through the display of filenames
E14: visualization is static and therefore the maintainer is not burdened by any UI adjustments

However, HTB is unfit for the purpose of showing source code due to potentially having multiple code clones per file/link to other file

## Possible improvements

Further work could be done to improve visualization. There is a zoomable treemap version and another possible is an overlay of the hierarchical tree bundling on a treemap. Especially the zooming treemap could achieve a reduction of mental overhead for larger systems. Another improvement would be to make HTB more interactive by adding a visualization method specifically for one selected file and showing all its contained code clones in other files. However, this would overlap with some of the functionality of the Treemap. A better alternative would perhaps be to highlight the filename and its linked files in the HTB when hovering over a code clone class in the Treemap.

# *how to use*

## Prerequisites

- Nodejs 8 or higher
- Python version 2 or 3
- Eclipse + Rascal plugin
- msys2 on windows or any linux terminal

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
cs = clones(a, 1); // for type 1
cs = clones(a, 2); // for type 1 & 2
outputClones(cs); // write code clones to html file
```

Open a command line in the assignment2 directory.

```
python clonesToWheel.py clones.txt ../visualization/src/clonesWheel.json
python clonesToTreemap.py clones.txt ../visualization/src/clonesTreemap.json
cp codeClones.html ../visualization/src/codeClones.html
```

Open a command line in the visualization directory.

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

# *Metrics Results*

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

# *time taken*

- Michael: 40 hours
- Constantijn: 40 hours

# *References*

[1] I. D. Baxter, A. Yahin, L. Moura, M. Sant'Anna and L. Bier, "Clone detection using abstract syntax trees," Proceedings. International Conference on Software Maintenance (Cat. No. 98CB36272), Bethesda, MD, 1998, pp. 368-377.
doi: 10.1109/ICSM.1998.738528
URL: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=738528&isnumber=15947

[2] Chanchal K. Roy, James R. Cordy, Rainer Koschke, Comparison and evaluation of code clone detection techniques and tools: A qualitative approach, In Science of Computer Programming, Volume 74, Issue 7, 2009, Pages 470-495, ISSN 0167-6423, DOI: https://doi.org/10.1016/j.scico.2009.02.007.
URL: http://www.sciencedirect.com/science/article/pii/S0167642309000367

[3] Lingxiao Jiang, Ghassan Misherghi, Zhendong Su, and Stephane Glondu. 2007. DECKARD: Scalable and Accurate Tree-Based Detection of Code Clones. In Proceedings of the 29th international conference on Software Engineering (ICSE '07). IEEE Computer Society, Washington, DC, USA, 96-105. DOI=http://dx.doi.org/10.1109/ICSE.2007.30
URL: https://dl.acm.org/citation.cfm?id=1248843

[4] M.-A.D Storey, F.D Fracchia, H.A Müller, Cognitive design elements to support the construction of a mental model during software exploration, In Journal of Systems and Software, Volume 44, Issue 3, 1999, Pages 171-185, ISSN 0164-1212, https://doi.org/10.1016/S0164-1212(98)10055-9.
URL: http://www.sciencedirect.com/science/article/pii/S0164121298100559
