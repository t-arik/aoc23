const fs = require('fs');

function readInput(filename) {
  const input = fs.readFileSync(filename, 'utf8');
  return input.trim().split('\n');
}

function countEnergizedTiles(grid) {
  const rows = grid.length;
  const cols = grid[0].length;

  const energized = new Set();
  const energized_with_directions = new Set();

  function isValid(x, y) {
    return x >= 0 && x < cols && y >= 0 && y < rows;
  }

  function isMirror(char) {
    return char === '/' || char === '\\';
  }

  function isSplitter(char, direction) {
    if (char === '|') {
      return direction === 'R' || direction === 'L';
    }
    if (char === '-') {
      return direction === 'U' || direction === 'D';
    }
  }

  function reflect(direction, mirror) {
    if (mirror === '/') {
      return {
        'U': 'R',
        'D': 'L',
        'R': 'U',
        'L': 'D'
      }[direction]
    } else if (mirror === '\\') {
      return {
        'U': 'L',
        'D': 'R',
        'R': 'D',
        'L': 'U'
      }[direction]
    }
  }

  const dx = {'U': 0, 'R': 1, 'D': 0, 'L': -1};
  const dy = {'U': -1, 'R': 0, 'D': 1, 'L': 0};

  function simulate(x, y, direction) {
    while (isValid(x, y) && !energized_with_directions.has(`${x},${y},${direction}`)) {
      const char = grid[y][x];

      energized.add(`${x},${y}`);
      energized_with_directions.add(`${x},${y},${direction}`);

      if (isMirror(char)) {
        direction = reflect(direction, char);
      } else if (isSplitter(char, direction)) {
        if (char === '|') {
          simulate(x, y - 1, 'U');
          simulate(x, y + 1, 'D');
        } else if (char === '-') {
          simulate(x + 1, y, 'R');
          simulate(x - 1, y, 'L');
        }
        return;
      }

      x += dx[direction];
      y += dy[direction];
    }
  }

  return energized.size;
}

const inputFilename = 'input16';
const grid = readInput(inputFilename);
const energizedCount = countEnergizedTiles(grid);

console.log(`Number of energized tiles: ${energizedCount}`);

