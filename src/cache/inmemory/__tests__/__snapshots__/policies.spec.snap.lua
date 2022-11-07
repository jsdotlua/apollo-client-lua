-- ROBLOX upstream: https://github.com/apollographql/apollo-client/blob/v3.4.2/src/cache/inmemory/__tests__/__snapshots__/policies.ts.snap

local snapshots = {}
snapshots["type policies complains about missing key fields 1"] = [[

[MockFunction] {
  "calls": Table {
    Table {
      "Missing field 'title' while writing result {\"theInformationBookData\":{\"subtitle\":\"A History, a Theory, a Flood\",\"author\":{\"name\":\"James Gleick\"},\"title\":\"The Information\",\"isbn\":\"1400096235\",\"__typename\":\"Book\"},\"year\":2011}",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
  },
}
]]

-- ROBLOX deviation START: convert Object and Array to Table
snapshots[ [=[type policies field policies assumes keyArgs:false when read and merge function present 1]=] ] = [=[

[MockFunction] {
  "calls": Table {
    Table {
      "Missing field 'a' while writing result {\"__typename\":\"TypeA\"}",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 1]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjI=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjI=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 2]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjI=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjU=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 3]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjU=",
        "hasNextPage": true,
        "hasPreviousPage": true,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjE=",
      },
      "totalCount": 1292,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 4]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjU=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 5]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjY=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Brooklyn Museum Apr 3rd – Aug 23rd 2015",
            "displayLabel": "Basquiat: The Unknown Notebooks",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjY=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 6]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/james-turrell\"}": Table {
    "__typename": "Artist",
    "bio": "American, born 1943, Los Angeles, California",
    "displayLabel": "James Turrell",
    "href": "/artist/james-turrell",
  },
  "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "American, 1960-1988, New York, New York, based in New York, New York",
    "displayLabel": "Jean-Michel Basquiat",
    "href": "/artist/jean-michel-basquiat",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjY=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Brooklyn Museum Apr 3rd – Aug 23rd 2015",
            "displayLabel": "Basquiat: The Unknown Notebooks",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjY=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
    "search:james turrell": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/james-turrell\"}",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjA=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 13531,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 7]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/james-turrell\"}": Table {
    "__typename": "Artist",
    "bio": "American, born 1943, Los Angeles, California",
    "displayLabel": "James Turrell",
    "href": "/artist/james-turrell",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjY=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Brooklyn Museum Apr 3rd – Aug 23rd 2015",
            "displayLabel": "Basquiat: The Unknown Notebooks",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjY=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
    "search:james turrell": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/james-turrell\"}",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjA=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 13531,
    },
  },
}
]=]

snapshots[ [=[type policies field policies can handle Relay-style pagination 8]=] ] = [=[

Table {
  "Artist:{\"href\":\"/artist/james-turrell\"}": Table {
    "__typename": "Artist",
    "bio": "American, born 1943, Los Angeles, California",
    "displayLabel": "James Turrell",
    "href": "/artist/james-turrell",
  },
  "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}": Table {
    "__typename": "Artist",
    "bio": "",
    "displayLabel": "Reminiscent of Basquiat",
    "href": "/artist/reminiscent-of-basquiat",
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "search:basquiat": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/jean-michel-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjE=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Damien Hirst, James Rosenquist, David Salle, Andy Warhol, Jeff Koons, Jean-Michel Basquiat, Keith Haring, Kiki Smith, Sandro Chia, Kenny Scharf, Mike Bidlo, Jon Schueler, William Wegman, David Wojnarowicz, Taylor Mead, William S. Burroughs, Michael Halsband, Rene Ricard, and Chris DAZE Ellis",
            "displayLabel": "ephemera BASQUIAT",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Nahmad Contemporary Mar 12th – May 31st 2019",
            "displayLabel": "Jean-Michel Basquiat | Xerox",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjM=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Banksy, SEEN, JonOne and QUIK at Artrust Oct 8th – Dec 16th 2017",
            "displayLabel": "STREET ART: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat, Shepard Fairey, COPE2, Pure Evil, Sickboy, Blade, Kurar, and LARS at Artrust",
            "displayLabel": "STREET ART 2: From Basquiat to Banksy",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjU=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/reminiscent-of-basquiat\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjY=",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "Past show featuring works by Jean-Michel Basquiat at Brooklyn Museum Apr 3rd – Aug 23rd 2015",
            "displayLabel": "Basquiat: The Unknown Notebooks",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjY=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 1292,
    },
    "search:james turrell": Table {
      "edges": Table {
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjA=",
          "node": Table {
            "__ref": "Artist:{\"href\":\"/artist/james-turrell\"}",
          },
        },
        Table {
          "__typename": "SearchableEdge",
          "cursor": "YXJyYXljb25uZWN0aW9uOjEx",
          "node": Table {
            "__typename": "SearchableItem",
            "description": "<placeholder for unknown description>",
            "displayLabel": "James Turrell: Light knows when we’re looking",
          },
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjEx",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjA=",
      },
      "totalCount": 13531,
    },
  },
}
]=]
-- ROBLOX deviation END

snapshots["type policies field policies can handle Relay-style pagination without args 1"] = [[

Table {
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "todos": Table {
      "edges": Table {
        Table {
          "__ref": "TodoEdge:edge1",
          "cursor": "YXJyYXljb25uZWN0aW9uOjI=",
        },
      },
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjI=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjI=",
      },
      "totalCount": 1292,
    },
  },
  "Todo:1": Table {
    "__typename": "Todo",
    "id": "1",
    "title": "Fix the tests",
  },
  "TodoEdge:edge1": Table {
    "__typename": "TodoEdge",
    "id": "edge1",
    "node": Table {
      "__ref": "Todo:1",
    },
  },
}
]]

-- ROBLOX deviation START: convert Object and Array to Table
snapshots[ [=[type policies field policies can include optional arguments in keyArgs 1]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 2]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 3]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 4]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 5]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":3}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 6]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":3}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 7]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":3}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":4}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]

snapshots[ [=[type policies field policies can include optional arguments in keyArgs 8]=] ] = [=[

Table {
  "Author:{\"name\":\"Nadia Eghbal\"}": Table {
    "__typename": "Author",
    "name": "Nadia Eghbal",
    "writings": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2,\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":1,\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"a\":3}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":2}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"b\":4}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{\"type\":\"Book\"}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
    "writings:{}": Table {
      Table {
        "__typename": "Book",
        "isbn": "0578675862",
        "title": "Working in Public: The Making and Maintenance of Open Source Software",
      },
    },
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "author": Table {
      "__ref": "Author:{\"name\":\"Nadia Eghbal\"}",
    },
  },
}
]=]
-- ROBLOX deviation END

snapshots["type policies field policies can handle Relay-style pagination without args 2"] = [[

Table {
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "todos": Table {
      "edges": Table {
        Table {
          "__ref": "TodoEdge:edge1",
          "cursor": "YXJyYXljb25uZWN0aW9uOjI=",
        },
      },
      "extraMetaData": "extra",
      "pageInfo": Table {
        "__typename": "PageInfo",
        "endCursor": "YXJyYXljb25uZWN0aW9uOjI=",
        "hasNextPage": true,
        "hasPreviousPage": false,
        "startCursor": "YXJyYXljb25uZWN0aW9uOjI=",
      },
      "totalCount": 1293,
    },
  },
  "Todo:1": Table {
    "__typename": "Todo",
    "id": "1",
    "title": "Fix the tests",
  },
  "TodoEdge:edge1": Table {
    "__typename": "TodoEdge",
    "id": "edge1",
    "node": Table {
      "__ref": "Todo:1",
    },
  },
}
]]

snapshots["type policies field policies read and merge can cooperate through options.storage 1"] = [[

[MockFunction] {
  "calls": Table {
    Table {
      "Missing field 'result' while writing result {\"__typename\":\"Job\",\"name\":\"Job #1\"}",
    },
    Table {
      "Missing field 'result' while writing result {\"__typename\":\"Job\",\"name\":\"Job #2\"}",
    },
    Table {
      "Missing field 'result' while writing result {\"__typename\":\"Job\",\"name\":\"Job #3\"}",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
    Table {
      "type": "return",
    },
    Table {
      "type": "return",
    },
  },
}
]]

snapshots["type policies field policies readField helper function calls custom read functions 1"] = [[

[MockFunction] {
  "calls": Table {
    Table {
      "Missing field 'blockers' while writing result {\"description\":\"grandchild task\",\"__typename\":\"Task\",\"id\":4}",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
  },
}
]]

snapshots["type policies field policies runs nested merge functions as well as ancestors 1"] = [[

[MockFunction] {
  "calls": Table {
    Table {
      "Missing field 'time' while writing result {\"__typename\":\"Event\",\"id\":123}",
    },
    Table {
      "Missing field 'time' while writing result {\"name\":\"Rooftop dog party\",\"__typename\":\"Event\",\"attendees\":[{\"name\":\"Inspector Beckett\",\"__typename\":\"Attendee\",\"id\":456},{\"__typename\":\"Attendee\",\"id\":234}],\"id\":345}",
    },
    Table {
      "Missing field 'name' while writing result {\"__typename\":\"Attendee\",\"id\":234}",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
    Table {
      "type": "return",
    },
    Table {
      "type": "return",
    },
  },
}
]]

snapshots["type policies readField warns if explicitly passed undefined `from` option 1"] = [[

[MockFunction] {
  "calls": Table {
    Table {
      "Undefined 'from' passed to readField with arguments [{\"from\":\"<Object.None>\",\"fieldName\":\"firstName\"}]",
    },
    Table {
      "Undefined 'from' passed to readField with arguments [\"lastName\",\"<nil>\"]",
    },
  },
  "results": Table {
    Table {
      "type": "return",
    },
    Table {
      "type": "return",
    },
  },
}
]]

snapshots[ [=[type policies support inheritance 1]=] ] = [=[

Table {
  "Cobra:{\"tagId\":\"Egypt30BC\"}": Table {
    "__typename": "Cobra",
    "scientificName": "naja haje",
    "tagId": "Egypt30BC",
    "venomous": true,
  },
  "Cottonmouth:{\"tagId\":\"CM420\"}": Table {
    "__typename": "Cottonmouth",
    "scientificName": "agkistrodon piscivorus",
    "tagId": "CM420",
    "venomous": true,
  },
  "Python:{\"tagId\":\"BigHug4U\"}": Table {
    "__typename": "Python",
    "scientificName": "malayopython reticulatus",
    "tagId": "BigHug4U",
    "venomous": false,
  },
  "ROOT_QUERY": Table {
    "__typename": "Query",
    "reptiles": Table {
      Table {
        "__ref": "Turtle:{\"tagId\":\"RedEaredSlider42\"}",
      },
      Table {
        "__ref": "Python:{\"tagId\":\"BigHug4U\"}",
      },
      Table {
        "__ref": "Cobra:{\"tagId\":\"Egypt30BC\"}",
      },
      Table {
        "__ref": "Cottonmouth:{\"tagId\":\"CM420\"}",
      },
    },
  },
  "Turtle:{\"tagId\":\"RedEaredSlider42\"}": Table {
    "__typename": "Turtle",
    "scientificName": "trachemys scripta elegans",
    "tagId": "RedEaredSlider42",
  },
}
]=]
return snapshots
