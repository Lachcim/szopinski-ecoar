#include <stdio.h>
#include <stdlib.h>

static const char* const errors[] = {
	"No input file specified\n",
	"Couldn't open input file\n",
	"Unrecognized file format\n",
	"Unsupported BMP format\n",
	"Only 24-bit BMP files are supported\n"
};

extern int find_markers(unsigned char* bitmap, unsigned int* xPos,
	unsigned int* yPos);

int main(int argc, char** argv) {
	//check for required argument
	if (argc < 2) {
		fputs(errors[0], stderr);
		return 1;
	}
	
	//open file for reading
	FILE* file = fopen(argv[1], "r");
	if (file == 0) {
		fputs(errors[1], stderr);
		return 2;
	}
	
	//obtain file size
	fseek(file, 0, SEEK_END);
	long fileSize = ftell(file);
	fseek(file, 0, SEEK_SET);
	
	//read file to buffer and close handle
	unsigned char* bitmap = malloc(fileSize);
	fread(bitmap, 1, fileSize, file);
	fclose(file);
	
	//allocate output location buffers
	unsigned int* xPos = malloc(sizeof(int) * 50);
	unsigned int* yPos = malloc(sizeof(int) * 50);
	
	//find markers
	int foundMarkers = find_markers(bitmap, xPos, yPos);
	
	//print marker locations or error message on error
	if (foundMarkers < 0) {
		fputs(errors[-foundMarkers], stderr);
		return 1 - foundMarkers;
	}
	for (int i = 0; i < foundMarkers; i++)
		printf("%d, %d\n", xPos[i], yPos[i]);
	
	//free memory
	free(bitmap);
	free(xPos);
	free(yPos);
}
