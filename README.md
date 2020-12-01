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


`JsonNull` = JSON Null value

`JsonBool` = JSON Boolean value (true/false)

`JsonNumber` = JSON Number value (Currently doesn't support floats)

`JsonString` = JSON String value

`JsonArray` = JSON Array (e.g : [ 1, "Hey I'm a string in an array!", true, [ true ] ] )

`JsonObject` = JSON Object (e.g : { "key" : "value" , "anotherKey" : true , "numbers?" : 12 })

## Parsers :
`jsonValue` = The main JSON parser

`jsonNull` = Parses `null` values in JSON

`jsonBool` = Parses JSON Boolean values (true/false)

`jsonString` = Parses JSON String values ("Example string")

`jsonArray` = Parses JSON Array values ( [ "example", "array", 1, true ] )

`jsonObject` = Parses JSON Objects ( { "exampleKey" : 1, "key2" : "value" } )

## Running a parser :
Just do

```haskell
runParser parser stringJson
```

(parser is a placeholder)
