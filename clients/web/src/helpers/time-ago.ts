const UNITS = [
  { label: 'year', seconds: 31536000 },
  { label: 'month', seconds: 2592000 },
  { label: 'week', seconds: 604800 },
  { label: 'day', seconds: 86400 },
  { label: 'hour', seconds: 3600 },
  { label: 'min', seconds: 60 },
  { label: 'sec', seconds: 1 }
];

/**
 * Helper function to get the largest unit and interval
 * to use for calculating time difference.
 */
const calculateTimeDifference = (time: number) => {
  for (let { label, seconds } of UNITS) {
    const interval = Math.floor(time / seconds);
    if (interval >= 1)
      return { interval: interval, unit: label };
  }
  
  return { interval: 0, unit: '' };
};

/**
 * Use this to convert a date to the relative time.
 * @param date the date to convert
 * @returns a string
 */
const timeAgo = (date: string | number | Date) => {
  const time = Math.floor( (new Date().valueOf() - new Date(date).valueOf()) / 1000 );
  const { interval, unit } = calculateTimeDifference(time);
  const suffix = interval === 1 ? '' : 's';
  return `${interval} ${unit}${suffix} ago`;
};

export default timeAgo;