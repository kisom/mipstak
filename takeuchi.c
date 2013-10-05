/*
 * Copyright (c) 2013 Kyle Isom <kyle@tyrfingr.is>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */


#include <sys/param.h>

#include <stdio.h>
#include <stdlib.h>
#include <time.h>


static	size_t	nruns = 0;


int
main(int argc, char *argv[])
{
	struct timeval	start, end;
	size_t		avg, total, runs;
	size_t		msec = 0;
	int		x, y, z;
	int		t = 0;

	if (argc != 4) {
		fprintf(stderr, "Please provide values for x, y, and z on ");
		fprintf(stderr, "the commandline.\n");
		return EXIT_FAILURE;
	}
	x = atoi(argv[1]);
	y = atoi(argv[2]);
	z = atoi(argv[3]);

	avg = total = runs = 0;


	for (runs = 0; runs < 1; runs++) {
	if (gettimeofday(&start, NULL) == -1) {
		perror("gettimeofday");
		return EXIT_FAILURE;
	}
	t = takeuchi(x, y, z);
	if (gettimeofday(&end, NULL) == -1) {
		perror("gettimeofday");
		return EXIT_FAILURE;
	}
	msec = end.tv_sec * 1000000;
	msec += end.tv_usec;
	msec -= (start.tv_sec * 1000000);
	msec -= start.tv_usec;
	total += msec;
	printf("nruns: %lu\n", (long unsigned)nruns);
	}

	printf("t: %d\n", t);
	printf("elapsed: %lu usec\n", (long unsigned)total);
	printf("elapsed: %lu sec\n", (long unsigned)(total / 1000000));
	printf("average: %lu usec\n", (long unsigned)(total / runs));
	return EXIT_SUCCESS;
}


int
takeuchi(int x, int y, int z)
{
	nruns++;
	/* printf("x=%d\ty=%d\tz=%d\n", x, y, z); */
	if (x <= y)
		return z;
	return takeuchi(takeuchi(x - 1, y, z),
			takeuchi(y - 1, z, x),
			takeuchi(z - 1, x, y));
}
