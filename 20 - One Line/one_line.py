from dataclasses import dataclass
from perlin_noise import PerlinNoise
from math import sqrt
import serial

@dataclass
class Coordinates:
    x: float
    y: float

def index_to_coords(index: int, x_resolution: int) -> (int, int):
    y = index // x_resolution
    x = index % x_resolution
    if y % 2 == 1:
        x = x_resolution - 1 - x
    return (x, y)

def generate_landscape(
    landscape_size: int,
    landscape_height: int,
    x_resolution: int,
    y_resolution: int
):
    coordinates_list: list(Coordinates) = []
    noise1 = PerlinNoise(octaves=6, seed=12026)
    noise2 = PerlinNoise(octaves=12, seed=12026)
    noise3 = PerlinNoise(octaves=24, seed=12026)
    for index in range(x_resolution * (y_resolution + 1)):
        (sample_x, sample_y) = index_to_coords(index, x_resolution)
        x = sample_x / x_resolution
        y = sample_y / y_resolution
        noise_val = noise1([x, y]) + 0.4 * noise2([x,y]) + 0.16 * noise3([x,y])
        z = (noise_val + 0.7) * 2 * max(0, 0.5 - sqrt((x - 0.5) ** 2 + (y - 0.5) ** 2))
        projected_x = int((x - y) * landscape_size) + landscape_size
        projected_y = int(0.5 * landscape_size * (x + y) + (z * landscape_height))
        coordinates_list.append(Coordinates(projected_x, projected_y))
    return coordinates_list

def main():
    ser = serial.Serial("/dev/ttyUSB0", 9600, timeout=1)
    landscape = generate_landscape(2048, 1024, 128, 16)
    ser.write(f"PU {landscape[0].x},{landscape[0].y};".encode("UTF-8"))
    for coordinate in landscape:
        ser.write(f"PD {coordinate.x},{coordinate.y};".encode("UTF-8"))

if __name__ == "__main__":
    main()