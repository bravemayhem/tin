export const PRODUCTS = [
  {
    id: "disposable_pad",
    label: "Disposable Pad",
    recommendedMinutes: 210,
    maxMinutes: 480,
  },
  {
    id: "tampon",
    label: "Tampon",
    recommendedMinutes: 360,
    maxMinutes: 480,
  },
  {
    id: "menstrual_cup",
    label: "Menstrual Cup",
    recommendedMinutes: 600,
    maxMinutes: 720,
  },
  {
    id: "menstrual_disc",
    label: "Menstrual Disc",
    recommendedMinutes: 600,
    maxMinutes: 720,
  },
  {
    id: "period_underwear",
    label: "Period Underwear",
    recommendedMinutes: 600,
    maxMinutes: 720,
  },
  {
    id: "reusable_pad",
    label: "Reusable Pad",
    recommendedMinutes: 300,
    maxMinutes: 720,
  },
  {
    id: "menstrual_sponge",
    label: "Menstrual Sponge",
    recommendedMinutes: 270,
    maxMinutes: 480,
  },
];

export function getRecommendedLabel(product) {
  const h = Math.floor(product.recommendedMinutes / 60);
  const m = product.recommendedMinutes % 60;
  return m > 0 ? `${h}h ${m}m` : `${h}h`;
}

export function getMaxLabel(product) {
  return `${Math.floor(product.maxMinutes / 60)}h`;
}
