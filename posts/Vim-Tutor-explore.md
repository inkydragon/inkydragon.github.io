---
title: Vim Tutor explore
date: 2017-04-30 19:52:23
categories:
tags:
  - vim
description:
  我真是闲
---


<!--more-->

>**ATTENTION:**
     The commands in the lessons will modify the text.  Make a copy of this
     file to practise on (if you started "vimtutor" this is already a copy).

我直接开的vim tutor所以没问题

# Lesson 1: TEXT EDITING
## MOVING THE CURSOR
```
** To move the cursor, press the h,j,k,l keys as indicated. **
          ^
          k		    Hint:  The h key is at the left and moves left.
    < h	      l >		   The l key is at the right and moves right.
          j			   The j key looks like a down arrow.
          v

```
`hj/lk` == **左下/右上**

## EXITING VIM
```
    1. Press the <ESC> key (to make sure you are in Normal mode).

    2. Type:	  :q! <ENTER>.
       This exits the editor, DISCARDING any changes you have made.
```
`:q!` 不保存退出

## DELETION

>** Press  x  to delete the character under the cursor. **
>
>NOTE: As you go through this tutor, do not try to memorize, learn by usage.

`x` 删除当店光标后的字符

## INSERTION
>** Press  i  to insert text. **

`i`== **insert** 即插入到光标处

## APPENDING
>** Press  A  to append text. **

`A`== **append** 在一行末尾插入
`a` 在光标后插入

## EDITING A FILE
>** Use  :wq  to save a file and exit. **

`:wq` 保存+退出
`w`== **write** && `q`== **quit**

## SUMMARY
```
1. The cursor is moved using either the arrow keys or the hjkl keys.
        h (left)	j (down)       k (up)	    l (right)

2. To start Vim from the shell prompt type:  vim FILENAME <ENTER>

3. To exit Vim type:	   <ESC>   :q!	 <ENTER>  to trash all changes.
            OR type:	   <ESC>   :wq	 <ENTER>  to save the changes.

4. To delete the character at the cursor type:  x

5. To insert or append text type:
 i   type inserted text   <ESC>		insert before the cursor
 A   type appended text   <ESC>         append after the line

NOTE: Pressing <ESC> will place you in Normal mode or will cancel
      an unwanted and partially completed command.
```

----

# Lesson 2: COMMANDS

## DELETION COMMANDS
>** Type  dw  to delete a word. **

`dw` 删除连续的空格/空行/一个词+其后的空格
`d`== **delete**

- `ABC_DEF` 被当做一个词
- `ABC.DEF` `foo-bar` 被当做两个词+一个符号

## MORE DELETION COMMANDS
>** Type  d$	to delete to the end of the line. **

`d$` 删除光标到行尾的所有内容
`$` ==/$/ ，正则表达式中的行尾

## ON OPERATORS AND MOTIONS
```
A short list of motions:
  w - until the start of the next word, EXCLUDING its first character.
  e - to the end of the current word, INCLUDING the last character.
  $ - to the end of the line, INCLUDING the last character.
```

`dw` 删除到下一个词 (删去了词间空格, 行尾句号不删去)
`de` 删除到词尾
`d$` 删除到行尾

## USING A COUNT FOR A MOTION
```
** Typing a number before a motion repeats it that many times. **

1. Move the cursor to the start of the line marked ---> below.

2. Type  2w  to move the cursor two words forward.

3. Type  3e  to move the cursor to the end of the third word forward.

4. Type  0  (zero) to move to the start of the line.
```

`1w` == 一个词+一个空格
`2w` 即向后移动两个词
`2e` 即向后移动到第二个词 **词尾**(最后一个字母)
`0`  回到行首

## USING A COUNT TO DELETE MORE
```
In the combination of the delete operator and a motion mentioned above you
insert a count before the motion to delete more:
 d   number   motion
```

`d2w` 删两个词 (包括最后的空格)
`d2e` 删两个词 (留空格)

## OPERATING ON LINES
```
** Type  dd   to delete a whole line. **

  2. Type  dd  to delete the line.
  ...
  4. Type   2dd   to delete two lines.
```

`dd`  删去一整行
`2dd` 删去两行

## THE UNDO COMMAND
> ** Press  u	to undo the last commands,   U  to fix a whole line. **

`u`== **undo** 撤销上一个举动
`U` 撤销一行上的所有更改 ~~时间间隔相近的一系列举动~~ ,可反撤销
`CTRL-R ` 撤销之前的命令

## SUMMARY
```
1. To delete from the cursor up to the next word type:      dw
2. To delete from the cursor to the end of a line type:     d$
3. To delete a whole line type:    dd

4. To repeat a motion prepend it with a number:   2w
5. The format for a change command is:
             operator   [number]   motion
   where:
     operator - is what to do, such as  d  for delete
     [number] - is an optional count to repeat the motion
     motion   - moves over the text to operate on, such as  w (word),
                $ (to the end of line), etc.

6. To move to the start of the line use a zero:  0

7. To undo previous actions, type: 	      u  (lowercase u)
   To undo all the changes on a line, type:   U  (capital U)
   To undo the undo's, type:		      CTRL-R
```

# Lesson 3: MORE COMMAND
## THE PUT COMMAND
>** Type	p  to put previously deleted text after the cursor. **

`p`== **puts** 把缓冲区中的一行，插入到当前行的下一行

## THE REPLACE COMMAND
>** Type  rx  to replace the character at the cursor with  x . **

`rx` 把当前光标所在的字母替换为`x`
`r`== **replace**

## THE CHANGE OPERATOR
>** To change until the end of a word, type  ce . **

`ce` 删除光标至词尾，然后插入
`c`== **change**

## MORE CHANGES USING c
```
** The change operator is used with the same motions as delete. **

1. The change operator works in the same way as delete.  The format is:

       c    [number]   motion

2. The motions are the same, such as   w (word) and  $ (end of line).
```
`c` 命令和 `d` 命令相似，只是多了插入
`c$` 删除光标到行尾，然后插入
`cw`/ `ce`相同，删除光标到词尾(不含空格)，然后插入

## SUMMARY
```
1. To put back text that has just been deleted, type   p .  This puts the
   deleted text AFTER the cursor (if a line was deleted it will go on the
   line below the cursor).

2. To replace the character under the cursor, type   r   and then the
   character you want to have there.

3. The change operator allows you to change from the cursor to where the
   motion takes you.  eg. Type  ce  to change from the cursor to the end of
   the word,  c$  to change to the end of a line.

4. The format for change is:

 c   [number]   motion
```

# Lesson 4: CURSOR AND FILE
## CURSOR LOCATION AND FILE STATUS
```
** Type CTRL-G to show your location in the file and the file status.
     Type  G  to move to a line in the file. **

     2. Press  G  to move you to the bottom of the file.
          Type  gg  to move you to the start of the file.

       3. Type the number of the line you were on and then  G .
```

`Ctrl+g` 显示文件路径，行号等信息
`gg` 转跳到文件头
`G` 转跳到文件尾
`233G` 转跳到 233 行

## THE SEARCH COMMAND
```
** Type  /  followed by a phrase to search for the phrase. **

3. To search for the same phrase again, simply type  n .
   To search for the same phrase in the opposite direction, type  N .

4. To search for a phrase in the backward direction, use  ?  instead of  / .

5. To go back to where you came from press  CTRL-O  (Keep Ctrl down while
   pressing the letter o).  Repeat to go back further.  CTRL-I goes forward.

NOTE: When the search reaches the end of the file it will continue at the
      start, unless the 'wrapscan' option has been reset.
```

`/word` (向下)在文件中搜索 word
`?word` (向上)搜索
`n`== **next** 向下继续搜索，
`N` 向上继续搜索
`Ctrl+o` 返回(上一个点)
`Ctrl+i` 前进(到下一个点)

## THE SUBSTITUTE COMMAND
```
** Type  :s/new/new/g  to substitute 'new' for 'new'. **

2. Type  :s/thee/the <ENTER> .  Note that this command only changes the
   first occurrence of "thee" in the line.

3. Now type  :s/thee/the/g .  Adding the  g  flag means to substitute
   globally in the line, change all occurrences of "thee" in the line.

4. To change every occurrence of a character string between two lines,
   type   :#,#s/old/new/g    where #,# are the line numbers of the range
                             of lines where the substitution is to be done.
   Type   :%s/old/new/g      to change every occurrence in the whole file.
   Type   :%s/old/new/gc     to find every occurrence in the whole file,
               with a prompt whether to substitute or not.
```
`:s/old/new` 在当前行中，替换 **第一个** old为new (无确认)
`:s/old/new/g` 在当前行中，替换所有的old为new (无确认)
`:123,456s/old/new/g` 在123~456行中，替换所有的old为new (无确认)
`:%s/old/new/g` 在 **整个文件** 中，替换所有的old为new (无确认)
`:%s/old/new/gc` 在 **整个文件** 中，替换所有的old为new (**有确认**)

参数解释：

- `/g`== **globally**
- `/c`== **confirm**

## SUMMARY
```
1. CTRL-G  displays your location in the file and the file status.
           G  moves to the end of the file.
   number  G  moves to that line number.
          gg  moves to the first line.

2. Typing  /	followed by a phrase searches FORWARD for the phrase.
   Typing  ?	followed by a phrase searches BACKWARD for the phrase.
   After a search type  n  to find the next occurrence in the same direction
   or  N  to search in the opposite direction.
   CTRL-O takes you back to older positions, CTRL-I to newer positions.

3. Typing  %	while the cursor is on a (,),[,],{, or } goes to its match.

4. To substitute new for the first old in a line type    :s/old/new
   To substitute new for all 'old's on a line type	   :s/old/new/g
   To substitute phrases between two line #'s type	   :#,#s/old/new/g
   To substitute all occurrences in the file type	   :%s/old/new/g
   To ask for confirmation each time add 'c'		   :%s/old/new/gc
```


# Lesson 5: EXTERNAL COMMAND
## HOW TO EXECUTE AN EXTERNAL COMMAND
>** Type  :!	followed by an external command to execute that command. **

`:!ls` 在cmd中执行`ls`并打开新窗口

{% asset_img ls.png 执行效果 %}

## MORE ON WRITING FILES
>** To save the changes made to the text, type  :w FILENAME. **

`:w FILENAME` 将文件写进`FILENAME`中

## SELECTING TEXT TO WRITE

```
** To save part of the file, type  v  motion  :w FILENAME **

NOTE:  Pressing  v  starts Visual selection.  You can move the cursor around
       to make the selection bigger or smaller.  Then you can use an operator
       to do something with the text.  For example,  d  deletes the text.
```
`v` == **visual** 进入可视化模式，用来选择文字
`:w FILENAME` -> `:'<,'>w FILENAME` 保存选中的文字到文件

## RETRIEVING AND MERGING FILES
>** To insert the contents of a file, type  :r FILENAME  **

`:r FILENAME` 将文件中的内容插入到光标所在处

## SUMMARY
```
1.  :!command  executes an external command.

    Some useful examples are:
 (MS-DOS)	  (Unix)
  :!dir		   :!ls		   -  shows a directory listing.
  :!del FILENAME   :!rm FILENAME   -  removes file FILENAME.

2.  :w FILENAME  writes the current Vim file to disk with name FILENAME.

3.  v  motion  :w FILENAME  saves the Visually selected lines in file
    FILENAME.

4.  :r FILENAME  retrieves disk file FILENAME and puts it below the
    cursor position.

5.  :r !dir  reads the output of the dir command and puts it below the
    cursor position.
```


# Lesson 6: OPEN COMMAND
## THE OPEN COMMAND
>** Type  o  to open a line below the cursor and place you in Insert mode. **

`o` 小写的o在当前行的 **下一行**，插入新行
`O` 大写的O在当前行的 **上一行**，插入新行

## THE APPEND COMMAND
```
  ** Type  a  to insert text AFTER the cursor. **

2. Press  e  until the cursor is on the end of  li .

3. Type an  a  (lowercase) to append text AFTER the cursor.

NOTE:  a, i and A all go to the same Insert mode, the only  
       difference is where the characters are inserted.

```
`i` 在当前光标处插入
`a` 在当前光标后插入
`e` 调到下一个词尾

## ANOTHER WAY TO REPLACE
```
** Type a capital  R  to replace more than one character. **

NOTE:  Replace mode is like Insert mode, but every typed character deletes an
       existing character.
```
`R` 在当前光标处开始替换模式

## COPY AND PASTE TEXT
```
** Use the  y  operator to copy text and  p  to paste it **

2. Start Visual mode with  v  and move the cursor to just before "first".

3. Type  y  to yank (copy) the highlighted text.

4. Move the cursor to the end of the next line:  j$b

5. Type  p  to put (paste) the text.  Then type:  a second <ESC> .

6. Use Visual mode to select " item.", yank it with  y , move to the end of
   the next line with  j$  and put the text there with  p .

   NOTE: you can also use  y  as an operator;  yw  yanks one word.
```
在`v`== **visual** 模式下选中要复制的文字
`y` == **yank** 复制选中的文字
`p` == **paste** 黏贴文字

`yw` 复制一个词
`j$` 选中到下一行行尾

## SET OPTION
```
** Set an option so a search or substitute ignores case **

1. Search for 'ignore' by entering:   /ignore  <ENTER>
   Repeat several times by pressing  n .

2. Set the 'ic' (Ignore case) option by entering:   :set ic

4. Set the 'hlsearch' and 'incsearch' options:  :set hls is

6. To disable ignoring case enter:  :set noic

NOTE:  To remove the highlighting of matches enter:   :nohlsearch
NOTE:  If you want to ignore case for just one search command, use  \c
     in the phrase:  /ignore\c  <ENTER>
```
`:set ic` \ `:set noic` 打开/关闭 忽略大小写(for 查找/替换)
`:set hls is` \ `:nohlsearch` 打开/关闭 高亮

## SUMMARY
```
1. Type  o  to open a line BELOW the cursor and start Insert mode.
   Type  O  to open a line ABOVE the cursor.

2. Type  a  to insert text AFTER the cursor.
   Type  A  to insert text after the end of the line.

3. The  e  command moves to the end of a word.

4. The  y  operator yanks (copies) text,  p  puts (pastes) it.

5. Typing a capital  R  enters Replace mode until  <ESC>  is pressed.

6. Typing ":set xxx" sets the option "xxx".  Some options are:
  'ic' 'ignorecase'	ignore upper/lower case when searching
'is' 'incsearch'	show partial matches for a search phrase
'hls' 'hlsearch'	highlight all matching phrases
   You can either use the long or the short option name.

7. Prepend "no" to switch an option off:   :set noic
```

# Lesson 7: HELP
## GETTING HELP
```
Vim has a comprehensive on-line help system.  To get started, try one of
these three:
- press the <HELP> key (if you have one)
- press the <F1> key (if you have one)
- type   :help <ENTER>

Read the text in the help window to find out how the help works.
Type  CTRL-W CTRL-W   to jump from one window to another.
Type    :q <ENTER>    to close the help window.
```

## CREATE A STARTUP SCRIPT
```
** Enable Vim features **

1. Start editing the "vimrc" file.  This depends on your system:
:e ~/.vimrc		for Unix
:e $VIM/_vimrc		for MS-Windows

2. Now read the example "vimrc" file contents:
:r $VIMRUNTIME/vimrc_example.vim

3. Write the file with:
:w
```

有cgywin的环境可以直接改 `~/.vimrc`

## COMPLETION
```
** Command line completion with CTRL-D and <TAB> **

NOTE:  Completion works for many commands.  Just try pressing CTRL-D and
       <TAB>.  It is especially useful for  :help .

```

## SUMMARY
```
1. Type  :help  or press <F1> or <Help>  to open a help window.

2. Type  :help cmd  to find help on  cmd .

3. Type  CTRL-W CTRL-W  to jump to another window

4. Type  :q  to close the help window

5. Create a vimrc startup script to keep your preferred settings.

6. When typing a  :  command, press CTRL-D to see possible completions.
   Press <TAB> to use one completion.
```

# For further reading and studying

- `:help user-manual`
- [Vim - Vi Improved - by Steve Oualline (Publisher: New Riders)](http://www.truth.sk/vim/vimbook-OPL.pdf)
- [Vim - ICCF Holland](http://iccf-holland.org/click5.html)
- Learning the Vi Editor - by Linda Lamb  
	Publisher: O'Reilly & Associates Inc.
