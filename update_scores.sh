#!/bin/bash
./saint_results.R && echo "Figures created..."
./saint_results_rev.R && echo "Figures created... "
chmod ugo+rx ~/pub_html/Clare/* && echo "Done. "

