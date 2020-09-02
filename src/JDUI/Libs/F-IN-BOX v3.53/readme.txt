What is F-IN-BOX v3.53, Delphi Edition? 
----------------------------

F-IN-BOX, Delphi Edition is a Delphi component to enhance Macromedia Flash
Player ActiveX features. It does not use its own engine to display
movies but provide a wrapper around official swflash.ocx/flash.ocx
code instead. Thus it is possible to avoid certain Macromedia Flash
Player ActiveX limitations.

Features at a glance 
--------------------

 * Load flash movies from any TStream descendant (TResourceStream, TMemoryStream, etc.). 
 * Create flash-enabled applications which are ready to work even where Macromedia Flash Player ActiveX 
   is not installed! 
 * Flash Transparent is fully supported!
 * Ability to play Flash Video (FLV) from stream.
 * Enable/disable flash sounds.
 * Get a snap image of the current flash movie frame.
 * Write code which is compatible with any version of Macromedia Flash Player ActiveX (3, 4, 5, 6, 7, 8, 9). 

Do all this and more with... F-IN-BOX, Delphi Edition! 

Delphi 3, 4, 5, 6, 7, 2005, 2006 and Builder 3, 4, 5, 6 are supported.
Macromedia Flash Player ActiveX 3, 4, 5, 6, 7, 8, 9 are supported. 

Load flash movies directly from any source (no temporary files!). Protect your flash movies. 
--------------------------------------------------------------------------------------------

It is known fact that the Flash Player ActiveX is able to load movies
at certain URLs only. You have to save the movie to a temporary
location from your application's resource before you can load it.
You'll have to generate a corresponding link that you can pass to the
Flash Player ActiveX and then delete the movie after. You'll have to
admit that this is extremely inconvenient. Apart from being
inconvenient there is a chance you'll fail when you try to create a
temporary file if you don't have the appropriate permission or don't
have access to a temporary folder. It is definitely not an appropriate
approach when security is an issue since your movie can be easily
intercepted. There is a solution! F-IN-BOX, Delphi Edition uses a different
approach of swflash.ocx/flash.ocx code loading. It is able to load
your movies directly to the ActiveX thereby avoiding the temporary
file step. Load flash movies from any TStream descendant
(TResourceStream, TMemoryStream, etc.)! The advantages are pretty
obvious. And you can also protect your movies from unauthorized access
using your favourite software protection application.

Create flash-enabled applications which are ready to work even when Macromedia Flash Player ActiveX is not installed! 
----------------------------------------------------------------------------------------------------------------------

One of the biggest problem using the Flash Player ActiveX is the
mandatory component registration. The common approach is to save
swflash.ocx/flash.ocx code to temporary files and then register them.
The disadvantages are the same as above mentioned - insufficient
permissions to save and register an swflash.ocx/flash.ocx. Now you can
forget about these problems! F-IN-BOX, Delphi Edition is able to use
swflash.ocx/flash.ocx from any source. For example, you can put an
swflash.ocx/flash.ocx code inside of your application's resources and
instruct F-IN-BOX, Delphi Edition to use it. It is important to note that
F-IN-BOX, Delphi Edition does not use temporary files and
swflash.ocx/flash.ocx registration but loads and uses the code
directly. No more user management rights problems - no more temporary
files and no more component registrations. It is up to you to decide
what swflash.ocx/flash.ocx to use - by default already registered
component is used.

Flash Transparent is fully supported!
--------------------------------------

Using FlashPlayerControl you are able to create applications based on 
transparent flash movies. You can create applications with translucency
non-rectangle forms (windows). Use Flash to make applications with modern
user interface, make a business logic using Delphi or Builder. 

Use TTransparentFlashPlayerControl Component to work with transparency. 
Put TTransparentFlashPlayerControl on a form. 
Set MakeParentTransparent property to True. That's all! 

Please note that form transparency is supported only under Win2k (or higher),
16 / 32 bpp display mode. To check if the transparency is supported use
global function IsFormTransparentAvailable.

Ability to play Flash Video (FLV) from stream
----------------------------------------------

Using FlashPlayerControl you are able to play Flash Video (FLV) from
external files, URL or directly from a TStream. When TFlashPlayerControl loads
Flash Video no temporary files are created everything runs directly from memory.
You can encrypt your video and put into application's resource - TFlashPlayerControl
loads FLV without ever saving or extracting the file to disk.

Enable/disable flash sounds
----------------------------

Using the component you can turn on/off all sounds in all loaded flash movies.

Get a snap image of the current flash movie frame
--------------------------------------------------

You can get a bitmap images from the current flash movie. It means you are able
create applications that can coverts Flash movies to a series of bitmaps, JPEGs and
others. Also you can build generated images to make an AVI video for example.

Write code which is compatible with any version of Macromedia Flash Player ActiveX (3, 4, 5, 6, 7, 8, 9)
------------------------------------------------------------------------------------------------------

One of the problem with Macromedia Flash Player ActiveX programming is that you
have to control what version of Macromedia Flash Player ActiveX you are using.
For example, the property "Stacking" exists only in Macromedia Flash Player ActiveX 5
but doesn't exist in later revisions. TFlashPlayerControl automatically detects what
Macromedia Flash Player ActiveX version is being used and prevents failure if access
to non existant properties/methods is attempted. Applications using TFlashPlayerControl
are not only compatible with Macromedia Flash Player ActiveX 3, 4, 5, 6, 7, but are also
"smart" about how Macromedia Flash Player ActiveX control is used. This makes your
application more robust which can result in fewer technical support issues.

-----------------------------------------------------------------
Copyright (c) 2004 - 2006 Softanics. All rights reserved.
Delphi is a trademark of Borland Software Corporation.
Macromedia and Shockwave Flash are trademarks of Macromedia, Inc.
