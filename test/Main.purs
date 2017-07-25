module Test.Main where

import Prelude

import Control.IxMonad (ibind, ipure)
import Control.IxMonad.Eff (IxEff, runIxEff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Symbol (SProxy(..))
import Global.Unsafe (unsafeStringify)
import Roskis (boxToRecord, getMysteryBox, insert)

thing :: forall eff.
  IxEff eff
    {}
    Void
    { b :: Int
    , a :: Int
    }
thing = do
  box <- getMysteryBox
  _ <- insert (SProxy :: SProxy "a") 123 box
  _ <- insert (SProxy :: SProxy "b") 456 box
  a <- boxToRecord box -- cloned here
  -- following line prevented from writing thanks to Void!
  -- _ <- insert (SProxy :: SProxy "c") 123 box
  ipure a
  where
    bind = ibind

main :: forall eff
  .  Eff
       ( console :: CONSOLE
       | eff
       )
       Unit
main = do
  a :: { a :: Int, b :: Int } <- runIxEff thing
  log $ unsafeStringify a
