{\rtf1\ansi\ansicpg1252\cocoartf1671\cocoasubrtf100
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red39\green78\blue204;\red255\green255\blue255;\red44\green55\blue61;
\red21\green129\blue62;\red42\green55\blue62;\red0\green0\blue0;\red107\green0\blue1;}
{\*\expandedcolortbl;;\cssrgb\c20000\c40392\c83922;\cssrgb\c100000\c100000\c100000;\cssrgb\c22745\c27843\c30588;
\cssrgb\c5098\c56471\c30980;\cssrgb\c21569\c27843\c30980;\cssrgb\c0\c0\c0;\cssrgb\c50196\c0\c0;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\sl360\partightenfactor0

\f0\fs24 \cf2 \cb3 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 CREATE\cf4 \strokec4  \cf2 \strokec2 OR\cf4 \strokec4  \cf2 \strokec2 REPLACE\cf4 \strokec4  \cf2 \strokec2 TABLE\cf4 \strokec4  \cf5 \strokec5 `glucosedatabyicu.mergingFiltering.14_revisedtotalgluc`\cf4 \strokec4  \cf2 \strokec2 AS\cf4 \strokec4  \cf6 \strokec6 (\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf4 \cb3   \cf2 \strokec2 SELECT\cf4 \cb1 \strokec4 \
\cb3     \cf7 \strokec7 a\cf4 \strokec4 .\cf6 \strokec6 *\cf4 \strokec4 ,\cb1 \
\cb3     \cf2 \strokec2 IFNULL\cf6 \strokec6 (\cf2 \strokec2 CAST\cf6 \strokec6 (\cf7 \strokec7 total_glucose_measurements\cf4 \strokec4  \cf2 \strokec2 AS\cf4 \strokec4  \cf2 \strokec2 FLOAT64\cf6 \strokec6 )\cf4 \strokec4  \cf6 \strokec6 /\cf4 \strokec4  \cf7 \strokec7 los\cf4 \strokec4 , \cf2 \strokec2 NULL\cf6 \strokec6 )\cf4 \strokec4  \cf2 \strokec2 AS\cf4 \strokec4  \cf7 \strokec7 totalgluc_perLOS\cf4 \cb1 \strokec4 \
\cb3   \cf2 \strokec2 FROM\cf4 \strokec4  \cf6 \strokec6 (\cf4 \cb1 \strokec4 \
\cb3     \cf2 \strokec2 SELECT\cf4 \cb1 \strokec4 \
\cb3       \cf7 \strokec7 d\cf4 \strokec4 .\cf6 \strokec6 *\cf4 \strokec4 ,\cb1 \
\cb3       \cf7 \strokec7 a\cf4 \strokec4 .\cf7 \strokec7 total_glucose_measurements\cf4 \cb1 \strokec4 \
\cb3     \cf2 \strokec2 FROM\cf4 \strokec4  \cf6 \strokec6 (\cf4 \cb1 \strokec4 \
\cb3       \cf2 \strokec2 SELECT\cf4 \cb1 \strokec4 \
\cb3         \cf7 \strokec7 hadm_id\cf4 \strokec4 ,\cb1 \
\cb3         \cf2 \strokec2 COUNT\cf6 \strokec6 (*)\cf4 \strokec4  \cf2 \strokec2 AS\cf4 \strokec4  \cf7 \strokec7 total_glucose_measurements\cf4 \cb1 \strokec4 \
\cb3       \cf2 \strokec2 FROM\cf4 \cb1 \strokec4 \
\cb3         \cf5 \strokec5 `glucose-390717.glucose1.actual_input_all`\cf4 \cb1 \strokec4 \
\cb3       \cf2 \strokec2 GROUP\cf4 \strokec4  \cf2 \strokec2 BY\cf4 \cb1 \strokec4 \
\cb3         \cf7 \strokec7 hadm_id\cf4 \cb1 \strokec4 \
\cb3     \cf6 \strokec6 )\cf4 \strokec4  \cf7 \strokec7 a\cf4 \cb1 \strokec4 \
\cb3     \cf2 \strokec2 JOIN\cf4 \cb1 \strokec4 \
\cb3       \cf5 \strokec5 `glucosedatabyicu.mergingFiltering.11_otherGluBool`\cf4 \strokec4  \cf7 \strokec7 d\cf4 \cb1 \strokec4 \
\cb3     \cf2 \strokec2 ON\cf4 \cb1 \strokec4 \
\cb3       \cf7 \strokec7 d\cf4 \strokec4 .\cf8 \strokec8 hadm_id\cf4 \strokec4  = \cf7 \strokec7 a\cf4 \strokec4 .\cf7 \strokec7 hadm_id\cf4 \cb1 \strokec4 \
\cb3   \cf6 \strokec6 )\cf4 \strokec4  \cf7 \strokec7 a\cf4 \cb1 \strokec4 \
\cb3   \cf2 \strokec2 ORDER\cf4 \strokec4  \cf2 \strokec2 BY\cf4 \cb1 \strokec4 \
\cb3     \cf7 \strokec7 a\cf4 \strokec4 .\cf7 \strokec7 subject_id\cf4 \cb1 \strokec4 \
\pard\pardeftab720\sl360\partightenfactor0
\cf6 \cb3 \strokec6 )\cf4 \cb1 \strokec4 \
}