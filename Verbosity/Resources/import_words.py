import sqlite3;
def mysplit (string):
    quote = False
    retval = []
    current = ""
    for char in string:
        if char == '"':
            quote = not quote
        elif char == ',' and not quote:
            retval.append(current)
            current = ""
        else:
            current += char
    retval.append(current)
    return retval

conn = sqlite3.connect('verbosity.sqlite3')
c = conn.cursor()

data = open("en_word_list.csv", "r").readlines()[1:]
for entry in data:
    # Parse values
    vals = mysplit(entry.strip())
   
    # Insert the row!
    print "Inserting %s..." % (vals[0])
    sql = "insert into words values(NULL, ?, ?, ?, 1)"
    c.execute(sql, vals)
 
# Done!
conn.commit()