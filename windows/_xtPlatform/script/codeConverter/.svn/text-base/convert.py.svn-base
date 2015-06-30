# -*- coding:utf-8 -*-
import os
import sys
import codecs

# 转换文件成无BOM的UTF-8
def convert(file,out_enc="UTF_8_sig"):
	encodings = ('utf-16', 'utf-8', 'gb2312', 'unicode', 'GBK')
	filecode = "";
	print ("load " +file)
	for encoding in encodings: 
		logfile = codecs.open(file, 'r', encoding=encoding) 
		try: 
			logfile.readline()
		except UnicodeError: 
			logfile.close()
		else: 
			filecode = encoding 
			logfile.close() 
			break
	print filecode
	if not filecode:	
		print 'can not find the file encode!!!!'
	else:
		print ("convert " +file)
		f=codecs.open(file,'r',filecode)
		new_content = f.read()
		codecs.open(file,'w',out_enc).write(new_content)

# 遍历目录
def explore(dir):
	for root,dirs,files in os.walk(dir):
		for file in files:
			path=os.path.join(root,file)
			convert(path)
		
def main():
	if len(sys.argv) < 2:
		print 'Use --help for more infomation'
		sys.exit()
	if sys.argv[1].startswith('--'):
		option = sys.argv[1][2:]
		if option == 'help':
			print '''"
			   This program prints files to the standard output.
			   Any number of files can be specified.
			   Options include:
			   filepath  : convert the file to UTF-8.
			   dirpath   : convert the all files under the dirpath to UTF-8.
			   --help    : Display this help'''  
		else:
			print 'Unknown option.'
			sys.exit()
	for path in sys.argv[1:]:
		if(os.path.isfile(path)):
			convert(path)
		elif os.path.isdir(path):
			explore(path)

if __name__=="__main__":
	main()