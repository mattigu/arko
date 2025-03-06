#include <stdio.h>
#include "f.h"
#include <SDL2/SDL.h>
#include <stdbool.h>
#include <malloc.h>

int display_image()
{
    int *x = malloc(sizeof(int));
    int *y = malloc(sizeof(int));
    // int scroll = 5000;
    bool quit = false;
    SDL_Event event;

    SDL_Init(SDL_INIT_VIDEO);


    SDL_Surface * image = SDL_LoadBMP( "images/sample.bmp");
    SDL_Surface * image2 = SDL_LoadBMP("images/sample.bmp");

    // getting data from image
    int width = image->w;
    int height = image->h;
    unsigned char bpp = image->format->BytesPerPixel;
    unsigned char padding = image->format->padding[1];
    void* pixels = image->pixels;

    SDL_Window * window = SDL_CreateWindow("My SDL Empty Window",
    SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width , height, 0);
        // SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800 , 800, 0);

// allocate buffers

// print for testing
    printf("%s %u\n", "width:", width);
    printf("%s %u\n", "height:", height);
    printf("%s %u\n", "bpp:", bpp);
    printf("%s %u\n", "padding:", padding);
    printf("%s %p\n", "pixels:", pixels);


// free buffers

    SDL_Renderer * renderer = SDL_CreateRenderer(window, -1, 0);
    SDL_Texture * texture = SDL_CreateTextureFromSurface(renderer, image);


    // SDL_Rect dstrect = {width, height, width, height};

    SDL_RenderCopy(renderer, texture, NULL, NULL);
    SDL_RenderPresent(renderer);

    bool blurred = false;

    while (!quit)
    {


        SDL_Delay(1);
        SDL_PollEvent(&event);

        switch (event.type)
        {
            case SDL_QUIT:
                quit = true;
                break;

            case SDL_MOUSEBUTTONDOWN:
                switch (event.button.button)
                {
                    case SDL_BUTTON_LEFT:
                        blurred = true;

                        SDL_GetMouseState(x, y);
                        printf("%i%s%i\n", width- *x, " ",*y);

                        // call assembly here with x, y with x, and height-y

                        SDL_LockSurface(image2);
                        SDL_LockSurface(image);
                        printf("%s%li\n","res", f(pixels, width, height, bpp, image2->pixels,padding,width -*x, *y));
                        SDL_UnlockSurface(image2);
                        SDL_LockSurface(image);
                        // updates texture based on new image
                        texture = SDL_CreateTextureFromSurface(renderer, image2);

                        SDL_RenderCopy(renderer, texture, NULL, NULL);
                        SDL_RenderPresent(renderer);
                        break;
                    case SDL_BUTTON_RIGHT:

                        if (blurred == true)
                            texture = SDL_CreateTextureFromSurface(renderer, image);
                        else
                        {
                            texture = SDL_CreateTextureFromSurface(renderer, image2);
                        }
                        blurred = !blurred;

                        SDL_RenderCopy(renderer, texture, NULL, NULL);
                        SDL_RenderPresent(renderer);
                        break;

                    }
        }

    }



    SDL_DestroyTexture(texture);
    SDL_FreeSurface(image);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);

    SDL_Quit();
    return 0;
}

int main(int argc, char* argv[])
{

    display_image();
    return 0;

}