#include <stdio.h>
#include <stdlib.h>

static const char* const errors[] = {
	"No input file specified\n",
	"Couldn't open input file\n",
	"Unrecognized file format\n",
	"Unsupported BMP format\n",
	"Only 24-bit BMP files are supported\n"
};

int main(int argc, char** argv) {
	//check for required argument
	if (argc < 2) {
		fprintf(stderr, errors[0]);
		return 1;
	}
	
	//open file for reading
	FILE* file = fopen(argv[1], "r");
	if (file == 0) {
		fprintf(stderr, errors[1]);
		return 2;
	}
	
	//obtain file size
	fseek(file, 0, SEEK_END);
	long fileSize = ftell(file);
	fseek(file, 0, SEEK_SET);
	
	//allocate file content buffer, ensure sufficient space for bitmap buffer
	if (fileSize < 322 * 242) fileSize = 322 * 242;
	unsigned char* bitmap = malloc(fileSize);
	
	//read file to buffer and close handle
	fread(bitmap, 1, fileSize, file);
	fclose(file);
	
	//allocate output location buffers
	unsigned int* xPos = malloc(sizeof(int) * 50);
	unsigned int* yPos = malloc(sizeof(int) * 50);
	
	//find markers
	int foundMarkers = 42;
	
	//print marker locations or error message on error
	if (foundMarkers < 0) {
		fprintf(stderr, errors[-foundMarkers]);
		return -foundMarkers;
	}
	for (int i = 0; i < foundMarkers; i++)
		printf("%d, %d\n", xPos[i], yPos[i]);
	
	//free memory
	free(bitmap);
	free(xPos);
	free(yPos);
}
