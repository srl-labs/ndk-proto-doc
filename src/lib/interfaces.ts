export interface Services {
    services: { [key: string]: Service };
}

export interface Service {
    name: string;
    description: string;
    versions: { [key: string]: Version };
}

export interface Version {
    source: string;
    documentation: string;
}