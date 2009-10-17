" ==========================================================================
" $Id: changesqlcase.vim,v 1.2 2003/12/31 21:30:24 culley Exp culley $
" ==========================================================================
"
" Description:
" This plugin is a function that wraps around a big substitution expression.
" The goal is to be able up upper case sql keywords from a visual selection.
" It is quite similar to this script:
"
" http://www.vim.org/scripts/script.php?script_id=305
"
" which uses insert mode abbreviations to capitalize as you type.  My script
" will be useful if you need to clean up existing scripts or if you are
" programming in another language and want to format sql inside of a string
" variable.  
"
" The sql keyword list is taken from the postgresql 7.4 docs:
"
" http://www.postgresql.org/docs/current/static/sql-keywords-appendix.html#KEYWORDS-TABLE
"
" Please send a patch to include keywords specific to the database you are
" working with.
"
" Installation:
"
" Place this script in your ~/.vim/plugin/ directory or source from your vimrc
" file. To use the script create a visual map:
"
" vmap <leader>uc  :call ChangeSqlCase()<cr>
"
" Customization:
" 1. Add the confirmation flag to the substitution if you are mostly doing
" single lines.  If you turn on confirmation on a multi-line visual selection
" you will need to cancel out of the confirmation for each line.
" 2. delete any keywords that cause you grief.
" 3. add any keywords that are missing for your database
"
" Todo:
" 1. This script could be modified to accept a database variable that altered
" the keyword list.
" 2. lowercase as well as uppercase
"
" Bugs:
" 
" As noted in the vim manual |10.3|:
"
"	When using Visual mode to select part of a line, or using CTRL-V to
"   select a block of text, the colon commands will still apply to whole
"   lines.  This might change in a future version of Vim.
"
" So if you select just the string in side of the quotes in the following
" example:
"
" test="select * from example" { dont update me }
" 
" the word 'update' after the end quote will also change case.  
"
" Contact:
" Culley Harrelson 
" vim@culley.fastmail.fm
" 

function! ChangeSqlCase()

" three atoms on the search:
"
" 1. \(\_^\|\W\)\@<= --------- non word character or begin of line \@<= is
" required to match to words next to each other (make the space non-inclusive)
" 2. long list of words separated by \|
" 3. \(\W\|\_$\)\@= ---------- just like item one for the other side of the
" match
"
" The substitution:
"
" \U\2\E/giec
"
:'<,'>s/\(\_^\|\W\)\@<=\(
	\abort\|
	\abs\|
	\absolute\|
	\access\|
	\acos\|
	\action\|
	\ada\|
	\add\|
	\adddate\|
	\addtime\|
	\admin\|
	\aes_decrypt\|
	\aes_encrypt\|
	\after\|
	\aggregate\|
	\alias\|
	\all\|
	\allocate\|
	\alter\|
	\analyse\|
	\analyze\|
	\and\|
	\any\|
	\are\|
	\array\|
	\as\|
	\asc\|
	\ascii\|
	\asensitive\|
	\asin\|
	\assertion\|
	\assignment\|
	\asymmetric\|
	\at\|
	\atan2\|
	\atan\|
	\atomic\|
	\authorization\|
	\avg\|
	\backward\|
	\before\|
	\begin\|
	\benchmark\|
	\between\|
	\bigint\|
	\bin\|
	\binary\|
	\bit\|
	\bit_and\|
	\bit_count\|
	\bit_length\|
	\bit_or\|
	\bit_xor\|
	\bitvar\|
	\blob\|
	\boolean\|
	\both\|
	\breadth\|
	\by\|
	\c\|
	\cache\|
	\call\|
	\called\|
	\cardinality\|
	\cascade\|
	\cascaded\|
	\case\|
	\cast\|
	\catalog\|
	\catalog_name\|
	\ceil\|
	\ceiling\|
	\chain\|
	\change\|
	\char\|
	\char_length\|
	\character\|
	\character_length\|
	\character_set_catalog\|
	\character_set_name\|
	\character_set_schema\|
	\characteristics\|
	\charset\|
	\check\|
	\checked\|
	\checkpoint\|
	\class\|
	\class_origin\|
	\clob\|
	\close\|
	\cluster\|
	\coalesce\|
	\cobol\|
	\coercibility\|
	\collate\|
	\collation\|
	\collation_catalog\|
	\collation_name\|
	\collation_schema\|
	\column\|
	\column_name\|
	\command_function\|
	\command_function_code\|
	\comment\|
	\commit\|
	\committed\|
	\completion\|
	\compress\|
	\concat\|
	\concat_ws\|
	\condition\|
	\condition_number\|
	\connect\|
	\connection\|
	\connection_id\|
	\connection_name\|
	\constraint\|
	\constraint_catalog\|
	\constraint_name\|
	\constraint_schema\|
	\constraints\|
	\constructor\|
	\contains\|
	\continue\|
	\conv\|
	\conversion\|
	\convert\|
	\convert_tz\|
	\copy\|
	\corresponding\|
	\cos\|
	\cot\|
	\count\|
	\crc32\|
	\create\|
	\createdb\|
	\createuser\|
	\cross\|
	\cube\|
	\curdate\|
	\current\|
	\current_date\|
	\current_path\|
	\current_role\|
	\current_time\|
	\current_timestamp\|
	\current_user\|
	\cursor\|
	\cursor_name\|
	\curtime\|
	\cycle\|
	\data\|
	\database\|
	\databases\|
	\date\|
	\date_add\|
	\date_format\|
	\date_sub\|
	\datediff\|
	\datetime_interval_code\|
	\datetime_interval_precision\|
	\day\|
	\day_hour\|
	\day_microsecond\|
	\day_minute\|
	\day_second\|
	\dayname\|
	\dayofmonth\|
	\dayofweek\|
	\dayofyear\|
	\deallocate\|
	\dec\|
	\decimal\|
	\declare\|
	\decode\|
	\default\|
	\defaults\|
	\deferrable\|
	\deferred\|
	\defined\|
	\definer\|
	\degrees\|
	\delayed\|
	\delete\|
	\delimiter\|
	\delimiters\|
	\depth\|
	\deref\|
	\des_decrypt\|
	\des_encrypt\|
	\desc\|
	\describe\|
	\descriptor\|
	\destroy\|
	\destructor\|
	\deterministic\|
	\diagnostics\|
	\dictionary\|
	\disconnect\|
	\dispatch\|
	\distinct\|
	\distinctrow\|
	\div\|
	\do\|
	\domain\|
	\double\|
	\drop\|
	\dual\|
	\dynamic\|
	\dynamic_function\|
	\dynamic_function_code\|
	\each\|
	\else\|
	\elseif\|
	\elt\|
	\enclosed\|
	\encode\|
	\encoding\|
	\encrypt\|
	\encrypted\|
	\end-exec\|
	\end\|
	\equals\|
	\escape\|
	\escaped\|
	\every\|
	\except\|
	\exception\|
	\excluding\|
	\exclusive\|
	\exec\|
	\execute\|
	\existing\|
	\exists\|
	\exit\|
	\exp\|
	\explain\|
	\export_set\|
	\external\|
	\extract\|
	\false\|
	\fetch\|
	\field\|
	\final\|
	\find_in_set\|
	\first\|
	\float4\|
	\float8\|
	\float\|
	\floor\|
	\for\|
	\force\|
	\foreign\|
	\format\|
	\fortran\|
	\forward\|
	\found\|
	\found_rows\|
	\free\|
	\freeze\|
	\from\|
	\from_days\|
	\from_unixtime\|
	\full\|
	\fulltext\|
	\function\|
	\g\|
	\general\|
	\generated\|
	\get\|
	\get_format\|
	\get_lock\|
	\global\|
	\go\|
	\goto\|
	\grant\|
	\granted\|
	\greatest\|
	\group\|
	\group_concat\|
	\grouping\|
	\handler\|
	\having\|
	\hex\|
	\hierarchy\|
	\high_priority\|
	\hold\|
	\host\|
	\hour\|
	\hour_microsecond\|
	\hour_minute\|
	\hour_second\|
	\identity\|
	\if\|
	\ifnull\|
	\ignore\|
	\ilike\|
	\immediate\|
	\immutable\|
	\implementation\|
	\implicit\|
	\in\|
	\including\|
	\increment\|
	\index\|
	\indicator\|
	\inet_aton\|
	\inet_ntoa\|
	\infile\|
	\infix\|
	\inherits\|
	\initialize\|
	\initially\|
	\inner\|
	\inout\|
	\input\|
	\insensitive\|
	\insert\|
	\instance\|
	\instantiable\|
	\instead\|
	\instr\|
	\int1\|
	\int2\|
	\int3\|
	\int4\|
	\int8\|
	\int\|
	\integer\|
	\intersect\|
	\interval\|
	\into\|
	\invoker\|
	\is\|
	\is_free_lock\|
	\is_used_lock\|
	\isnull\|
	\isolation\|
	\iterate\|
	\join\|
	\k\|
	\key\|
	\key_member\|
	\key_type\|
	\keys\|
	\kill\|
	\label\|
	\lancompiler\|
	\language\|
	\large\|
	\last\|
	\last_day\|
	\last_insert_id\|
	\lateral\|
	\lcase\|
	\leading\|
	\least\|
	\leave\|
	\left\|
	\length\|
	\less\|
	\level\|
	\like\|
	\limit\|
	\lines\|
	\listen\|
	\ln\|
	\load\|
	\load_file\|
	\local\|
	\localtime\|
	\localtimestamp\|
	\locate\|
	\location\|
	\locator\|
	\lock\|
	\log10\|
	\log2\|
	\log\|
	\long\|
	\longblob\|
	\longtext\|
	\loop\|
	\low_priority\|
	\lower\|
	\lpad\|
	\ltrim\|
	\m\|
	\make_set\|
	\makedate\|
	\maketime\|
	\map\|
	\master_pos_wait\|
	\match\|
	\max\|
	\maxvalue\|
	\md5\|
	\mediumblob\|
	\mediumint\|
	\mediumtext\|
	\message_length\|
	\message_octet_length\|
	\message_text\|
	\method\|
	\microsecond\|
	\mid\|
	\middleint\|
	\min\|
	\minute\|
	\minute_microsecond\|
	\minute_second\|
	\minvalue\|
	\mod\|
	\mode\|
	\modifies\|
	\modify\|
	\module\|
	\month\|
	\monthname\|
	\more\|
	\move\|
	\mumps\|
	\name\|
	\name_const\|
	\names\|
	\national\|
	\natural\|
	\nchar\|
	\nclob\|
	\new\|
	\next\|
	\no\|
	\no_write_to_binlog\|
	\nocreatedb\|
	\nocreateuser\|
	\none\|
	\not\|
	\nothing\|
	\notify\|
	\notnull\|
	\now\|
	\null\|
	\nullable\|
	\nullif\|
	\number\|
	\numeric\|
	\object\|
	\oct\|
	\octet_length\|
	\of\|
	\off\|
	\offset\|
	\oids\|
	\old\|
	\old_password\|
	\on\|
	\only\|
	\open\|
	\operation\|
	\operator\|
	\optimize\|
	\option\|
	\optionally\|
	\options\|
	\or\|
	\ord\|
	\order\|
	\ordinality\|
	\out\|
	\outer\|
	\outfile\|
	\output\|
	\overlaps\|
	\overlay\|
	\overriding\|
	\owner\|
	\pad\|
	\parameter\|
	\parameter_mode\|
	\parameter_name\|
	\parameter_ordinal_position\|
	\parameter_specific_catalog\|
	\parameter_specific_name\|
	\parameter_specific_schema\|
	\parameters\|
	\partial\|
	\pascal\|
	\password\|
	\path\|
	\pendant\|
	\period_add\|
	\period_diff\|
	\pi\|
	\placing\|
	\pli\|
	\position\|
	\postfix\|
	\pow\|
	\power\|
	\precision\|
	\prefix\|
	\preorder\|
	\prepare\|
	\preserve\|
	\primary\|
	\prior\|
	\privileges\|
	\procedural\|
	\procedure\|
	\public\|
	\purge\|
	\quarter\|
	\quote\|
	\radians\|
	\rand\|
	\read\|
	\reads\|
	\real\|
	\recheck\|
	\recursive\|
	\ref\|
	\references\|
	\referencing\|
	\regexp\|
	\reindex\|
	\relative\|
	\release\|
	\release_lock\|
	\rename\|
	\repeat\|
	\repeatable\|
	\replace\|
	\require\|
	\reset\|
	\restart\|
	\restrict\|
	\result\|
	\return\|
	\returned_length\|
	\returned_octet_length\|
	\returned_sqlstate\|
	\returns\|
	\reverse\|
	\revoke\|
	\right\|
	\rlike\|
	\role\|
	\rollback\|
	\rollup\|
	\round\|
	\routine\|
	\routine_catalog\|
	\routine_name\|
	\routine_schema\|
	\row\|
	\row_count\|
	\rows\|
	\rpad\|
	\rtrim\|
	\rule\|
	\savepoint\|
	\scale\|
	\schema\|
	\schema_name\|
	\schemas\|
	\scope\|
	\scroll\|
	\search\|
	\sec_to_time\|
	\second\|
	\second_microsecond\|
	\section\|
	\security\|
	\select\|
	\self\|
	\sensitive\|
	\separator\|
	\sequence\|
	\serializable\|
	\server_name\|
	\session\|
	\session_user\|
	\set\|
	\setof\|
	\sets\|
	\sha1\|
	\sha\|
	\share\|
	\show\|
	\sign\|
	\similar\|
	\simple\|
	\sin\|
	\size\|
	\sleep\|
	\smallint\|
	\some\|
	\soname\|
	\soundex\|
	\sounds\|
	\source\|
	\space\|
	\spatial\|
	\specific\|
	\specific_name\|
	\specifictype\|
	\sql\|
	\sql_big_result\|
	\sql_calc_found_rows\|
	\sql_small_result\|
	\sqlcode\|
	\sqlerror\|
	\sqlexception\|
	\sqlstate\|
	\sqlwarning\|
	\sqrt\|
	\ssl\|
	\stable\|
	\start\|
	\starting\|
	\state\|
	\statement\|
	\static\|
	\statistics\|
	\std\|
	\stddev\|
	\stddev_pop\|
	\stddev_samp\|
	\stdin\|
	\stdout\|
	\storage\|
	\str_to_date\|
	\straight_join\|
	\strcmp\|
	\strict\|
	\structure\|
	\style\|
	\subclass_origin\|
	\subdate\|
	\sublist\|
	\substr\|
	\substring\|
	\substring_index\|
	\subtime\|
	\sum\|
	\symmetric\|
	\sysdate\|
	\sysid\|
	\system\|
	\system_user\|
	\table\|
	\table_name\|
	\tan\|
	\temp\|
	\template\|
	\temporary\|
	\terminate\|
	\terminated\|
	\than\|
	\then\|
	\time\|
	\time_format\|
	\time_to_sec\|
	\timediff\|
	\timestamp\|
	\timestampadd\|
	\timestampdiff\|
	\timezone_hour\|
	\timezone_minute\|
	\tinyblob\|
	\tinyint\|
	\tinytext\|
	\to\|
	\to_days\|
	\toast\|
	\trailing\|
	\transaction\|
	\transaction_active\|
	\transactions_committed\|
	\transactions_rolled_back\|
	\transform\|
	\transforms\|
	\translate\|
	\translation\|
	\treat\|
	\trigger\|
	\trigger_catalog\|
	\trigger_name\|
	\trigger_schema\|
	\trim\|
	\true\|
	\truncate\|
	\trusted\|
	\type\|
	\ucase\|
	\uncommitted\|
	\uncompress\|
	\uncompressed_length\|
	\under\|
	\undo\|
	\unencrypted\|
	\unhex\|
	\union\|
	\unique\|
	\unix_timestamp\|
	\unknown\|
	\unlisten\|
	\unlock\|
	\unnamed\|
	\unnest\|
	\unsigned\|
	\until\|
	\update\|
	\upgrade\|
	\upper\|
	\usage\|
	\use\|
	\user\|
	\user_defined_type_catalog\|
	\user_defined_type_name\|
	\user_defined_type_schema\|
	\using\|
	\utc_date\|
	\utc_time\|
	\utc_timestamp\|
	\uuid\|
	\vacuum\|
	\valid\|
	\validator\|
	\value\|
	\values\|
	\var_pop\|
	\var_samp\|
	\varbinary\|
	\varchar\|
	\varcharacter\|
	\variable\|
	\variance\|
	\varying\|
	\verbose\|
	\version\|
	\view\|
	\volatile\|
	\week\|
	\weekday\|
	\weekofyear\|
	\when\|
	\whenever\|
	\where\|
	\while\|
	\with\|
	\without\|
	\work\|
	\write\|
	\xor\|
	\year\|
	\year_month\|
	\yearweek\|
	\zerofill\|
	\zone
    \\)\(\W\|\_$\)\@=/\U\2\E/gie

" Removed:
"    \sql\| ===== this was changing the case of my variable name...
"
endfunction


