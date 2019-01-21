:loop
N

#process [
s/\[\r\n/[/

#process (
s/(\r\n/(/

s/\r\n/\t/

#remove multiple \t
s/\t\t//

#process ]
s/\t]/]/

#process )
s/\t)/)/

/[],)]/!t loop
