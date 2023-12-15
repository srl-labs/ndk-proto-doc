import { error } from '@sveltejs/kit';

import yaml from 'js-yaml';

import type { Services } from '$lib/interfaces';
import ndkLoad from '$lib/ndk.yaml?raw';

const services = yaml.load(ndkLoad) as Services;

/** @type {import('./$types').PageLoad} */
export async function load({ url, fetch, params }) {
  const pathUrl = url.origin;

  // service name from the url?
  const s = params.service;

  // check if the referenced service exists in the ndk.yaml
  let found;
  found = Object.keys(services['services']).includes(s);
  if (found) {
    let invalidKeys = [];
    for (const [key, value] of url.searchParams.entries()) {
      if (key != "version") invalidKeys.push(key);
    }
    if (invalidKeys.length > 0) throw error(404, "Invalid URL Parameters");

    let ov = Object.keys(services['services'][s].versions);
    let v = ov[0];
    if (url.searchParams.has("version")) {
      v = url.searchParams.get("version").trim();
      if (!ov.includes(v)) {
        throw error(404, "Unsupported Version");
      }
    }

    try {
      const fetchUrl = `${pathUrl}/ndk-services/${s}/${v}/proto-doc.json`;
      const resp = await fetch(fetchUrl);
      const protoDoc = await resp.json();

      return {
        services: service: s, version: v,
        protoDoc: await protoDoc
      }
    } catch (e) {
      throw error(404, "Error fetching proto definition");
    }
  }
  else throw error(404, "Unsupported Service");
}
