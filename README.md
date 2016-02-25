# quicklearn

<object width="480" height="386" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000">
  <param name="flashvars" value="vid=18198707&amp;autoplay=false"/>
  <param name="allowfullscreen" value="true"/>
  <param name="allowscriptaccess" value="always"/>
  <param name="src" value="http://www.ustream.tv/flash/viewer.swf"/>
  <embed flashvars="vid=18198707&amp;autoplay=false" width="480" height="386" allowfullscreen="true" allowscriptaccess="always" src="http://www.ustream.tv/flash/viewer.swf" type="application/x-shockwave-flash"></embed>
</object>
<br /><a href="http://www.ustream.tv/" style="padding: 2px 0px 4px; width: 400px; background: #ffffff; display: block; color: #000000; font-weight: normal; font-size: 10px; text-decoration: underline; text-align: center;" target="_blank">Video streaming by Ustream</a>

Quicklearn is a quickrun plugin and is a Unite plugin at the same time.

Quicklearn compiles the code you are writing, opens another window, and shows the intermediate code of the language.

* C
    * Assembly language (gcc)
    * LLVM IR (clang)
* Haskell
    * Core (ghc)
* CoffeeScript
    * JavaScript
* Ruby
    * YARV Instructions (CRuby)

## Usage

    :Unite quicklearn -immediately

Sample configulation for `~/.vimrc`:

    nnoremap <space>R :<C-u>Unite quicklearn -immediately<Cr>

Don't forget the `-immediately` option.

## Author

Tatsuhiro Ujihisa

# License

GPLv3 or any later versions
