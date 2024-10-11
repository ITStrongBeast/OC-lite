#!/bin/bash

grep -ERoh "[a-zA-Z.+-]+@[a-zA-Z-]+\.[a-zA-Z.-]+" /etc | sort -u | paste -sd "," > etc_emails.lst
