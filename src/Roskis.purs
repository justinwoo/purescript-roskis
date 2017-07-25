module Roskis where

import Prelude

import Control.IxMonad.Eff (IxEff(IxEff))
import Control.Monad.Eff (Eff)
import Type.Prelude (class IsSymbol, class RowLacks, SProxy, reflectSymbol)

foreign import data MysteryBox :: Type

foreign import getMysteryBox_ :: forall eff
  .  Eff eff MysteryBox

foreign import unsafeSetMysteryBox :: forall a eff
  .  String
  -> a
  -> MysteryBox
  -> Eff eff Unit

getMysteryBox :: forall eff
  .  IxEff eff {} {} MysteryBox
getMysteryBox = IxEff $ getMysteryBox_

insert :: forall r1 r2 l a eff
  .  IsSymbol l
  => RowLacks l r1
  => RowCons l a r1 r2
  => SProxy l
  -> a
  -> MysteryBox
  -> IxEff eff { | r1 } { | r2 } Unit
insert nameP x box = IxEff $ unsafeSetMysteryBox (reflectSymbol nameP) x box

foreign import boxToRecord_ :: forall eff row
  .  MysteryBox
  -> Eff eff { | row }

-- seals the box with Void magic
boxToRecord :: forall row eff
  .  MysteryBox
  -> IxEff eff { | row } Void { | row }
boxToRecord box = IxEff $ boxToRecord_ box
