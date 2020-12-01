# JsonParser
## How to use in your project :
First of all , import it using :

```haskell
import JsonParser
```

Then , you can either use the :

```haskell
parseFile filePath jsonValue
```

method which has a type of :

```haskell
parseFile :: String -> Parser a -> IO (Maybe a)
```

or you can do :
```haskell
runParser jsonValue "json code ..."
```

which has type of :

```haskell
runParser :: Parser a -> String -> Maybe (String a)
```
## Types :
<br />
`JsonNull` = JSON Null value<br />
`JsonBool` = JSON Boolean value (true/false)<br />
`JsonNumber` = JSON Number value (Currently doesn't support floats)<br />
`JsonString` = JSON String value<br />
`JsonArray` = JSON Array (e.g : [ 1, "Hey I'm a string in an array!", true, [ true ] ] )<br />
`JsonObject` = JSON Object (e.g : { "key" : "value" , "anotherKey" : true , "numbers?" : 12 })<br />

## Parsers :
`jsonValue` = The main JSON parser<br />
`jsonNull` = Parses `null` values in JSON<br />
`jsonBool` = Parses JSON Boolean values (true/false)<br />
`jsonString` = Parses JSON String values ("Example string")<br />
`jsonArray` = Parses JSON Array values ( [ "example", "array", 1, true ] )<br />
`jsonObject` = Parses JSON Objects ( { "exampleKey" : 1, "key2" : "value" } )<br />

## Running a parser :
Just do

```haskell
runParser parser stringJson
```

(parser is a placeholder)
