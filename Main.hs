module Main where
-- https://www.youtube.com/watch?v=N9RUqGYuGfw
import Data.Char
import Control.Applicative

data JsonValue = JsonNull
               | JsonBool Bool
               | JsonNumber Integer -- No support for floats ... What a shame!
               | JsonString String
               | JsonArray [JsonValue]
               | JsonObject [(String, JsonValue)]
               deriving (Show, Eq)

-- NOTE: No proper error reporting
newtype Parser a = Parser {runParser :: String -> Maybe (String, a)}

instance Functor Parser where
  fmap f (Parser p) = Parser $ \input -> do
                                (input', x) <- p input
                                Just (input', f x)

instance Applicative Parser where
  pure x = Parser $ \input -> Just (input, x)
  (Parser p1) <*> (Parser p2) = Parser $ \input -> do
                                (input', f) <- p1 input
                                (input'', a) <- p2 input'
                                Just (input'', f a)

instance Alternative Parser where
  empty = Parser $ \_ -> Nothing
  (Parser p1) <|> (Parser p2) = Parser $ \input -> p1 input <|> p2 input

jsonNull :: Parser JsonValue
jsonNull = (\_ -> JsonNull) <$> stringP "null"

charP :: Char -> Parser Char
charP x = Parser $ f
  where
    f (y:ys)
        | y == x = Just (ys, x)
        | otherwise = Nothing
    f [] = Nothing

stringP :: String -> Parser String
stringP = sequenceA . fmap charP

jsonBool :: Parser JsonValue
jsonBool = f <$> (stringP "true" <|> stringP "false")
  where f "true"  = JsonBool True
        f "false" = JsonBool False
        f _       = undefined

spanP :: (Char -> Bool) -> Parser String
spanP f = Parser $ \input ->
  let (taken,rest) = span f input
        in Just (rest, taken)

notNull :: Parser [a] -> Parser [a]
notNull (Parser p) = Parser $ \input -> do
                       (input', xs) <- p input
                       if null xs
                          then Nothing
                          else Just (input', xs)

jsonNumber :: Parser JsonValue
jsonNumber = f <$> notNull (spanP isDigit)
  where f ds = JsonNumber $ read ds

stringLiteral :: Parser String
stringLiteral = charP '"' *> spanP (/= '"') <* charP '"'

jsonString :: Parser JsonValue
jsonString = JsonString <$> (stringLiteral)

ws :: Parser String
ws = spanP isSpace

sepBy :: Parser a -> Parser b -> Parser [b]
sepBy sep element = (:) <$> element <*> many (sep *> element)
  <|> pure []

jsonArray :: Parser JsonValue
jsonArray = JsonArray <$> (charP '[' *> ws *> elements <* ws <* charP ']')
  where elements = sepBy (ws *> charP ',' <* ws) jsonValue

jsonObject :: Parser JsonValue
jsonObject =
  JsonObject <$> (charP '{' *> ws *> sepBy (ws *> charP ',' <* ws) pairs <* ws <* charP '}')
  where
    pairs =
        (\key _  value-> (key, value)) <$> stringLiteral
          <*> (ws *> charP ':' <* ws)
          <*> jsonValue

jsonValue :: Parser JsonValue
jsonValue = jsonNull <|> jsonBool <|> jsonNumber <|> jsonString <|> jsonArray <|> jsonObject

parseFile :: FilePath -> Parser a -> IO (Maybe a)
parseFile filename parser = do
  input <- readFile filename
  return (snd <$> runParser parser input)

main :: IO ()
main = undefined
