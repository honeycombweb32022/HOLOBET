import { darkColors, lightColors } from "../../theme/colors";

export interface NavThemeType {
  background: string;
  backgroundHeader?: string;
}

export const light: NavThemeType = {
  background: lightColors.backgroundAlt,
  backgroundHeader: lightColors.backgroundHeaderMenu,
};

export const dark: NavThemeType = {
  background: darkColors.backgroundAlt,
};
